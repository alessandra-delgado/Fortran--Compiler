
(* Produção de código para a linguagem Arith *)

open Format
open X86_64
open Ast

(* Exceção por lançar quando uma variável (local ou global) é mal utilizada *)
exception VarUndef of string

(* Tamanho em byte da frame (cada variável local ocupa 8 bytes) *)
let frame_size = ref 0
let lif = ref 0
let lbool = ref 0
let lloop = ref 0
let lfun = ref 0

(* As variáveis globais estão arquivadas numa HashTable *)
let (genv : (string, unit) Hashtbl.t) = Hashtbl.create 17

(* Utiliza-se  uma tabela associativa cujas chaves são as variáveis locais
   (strings) cujo valor associado é a posição da variável relativamente
   a $fp/%rsb (em bytes)
*)
module StrMap = Map.Make(String)

(* Compilação de uma expressão *)
let compile_expr e =
  (* Função recursiva local de compile_expr utilizada para gerar o código
     máquina da árvore de sintaxe  abstracta associada a um valor de tipo
     Ast.expr ; na sequência da execução deste código, o valor deve estar
     no topo da pilha *)
  let rec comprec env next e = match e with
    | Cst i ->
      pushq (imm i)
    | Var x ->

    begin
      try 
        let ofs = StrMap.find x env in
        movq (ind ~ofs:(-ofs) rbp) (reg rax) ++
        pushq (reg rax)
      with Not_found ->
        let _ = Hashtbl.find genv x in
        pushq (lab x)
      end 
        
    | Binop (Div, e1, e2)->
      comprec env next e1 ++
      comprec env next e2 ++
      movq (imm 0) (reg rdx) ++
      popq rbx ++
      popq rax ++
      idivq (reg rbx) ++
      pushq (reg rax)

    | Binop (Add|Sub|Mul as o, e1, e2)->
      let op = match o with
       | Add -> addq
       | Sub -> subq
       | Mul -> imulq
       | _ -> failwith "Not implemented"
    in

      comprec env next e1 ++
      comprec env next e2 ++
      popq rax ++
      popq rbx ++
      
      op (reg rax) (reg rbx) ++
      pushq (reg rbx)

    | Binop (Eq|Ne|Ge|Gt|Le|Lt as o, e1, e2) -> 
      let set = match o with
      | Eq -> sete
      | Ne -> setne
      | Ge -> setge
      | Gt -> setg
      | Le -> setle
      | Lt -> setl
      | _ -> failwith "Not implemented"
    in
    comprec env next e1 ++
    comprec env next e2 ++

    popq rax ++ (*e2*)
    popq rbx ++ (*e1*)
    cmpq (reg rax) (reg rbx) ++
    set (reg al) ++
    movzbq (reg al) rax ++
    pushq (reg rax)

    | Binop(Or|And as o, e1, e2) ->
      let jump, value = match o with 
      | Or -> je, 1
      | And -> jne, 0
      | _ -> failwith "Not implemented"
    in

    lbool := !lbool + 1;
    let lbool = !lbool in
    comprec env next e1 ++
    popq rax ++
    cmpq (imm 0) (reg rax) ++
    jump (Printf.sprintf ".bool_condition%d" lbool)++
    pushq (imm value) ++
    jmp (Printf.sprintf ".bool_end%d" lbool) ++

    label (Printf.sprintf ".bool_condition%d" lbool) ++
      comprec env next e2 ++
          
    label (Printf.sprintf ".bool_end%d" lbool)

    | Unop(Not as o, e) ->
      let set = match o with
      | Not -> sete
      | _ -> failwith "Not implemented"
    in

    comprec env next e ++
    popq rax ++
    cmpq (imm 0) (reg rax) ++
    set (reg al) ++
    movzbq (reg al) rax ++
    pushq (reg rax)

    
      
    | Letin (x, e1, e2) ->
        if !frame_size = next then frame_size := 8 + !frame_size;

        comprec env next e1 ++
        popq rax ++
        movq (reg rax) (ind ~ofs:(-next) rbp) ++
        
        comprec (StrMap.add x next env) (next + 8) e2
    
  in
  comprec StrMap.empty 0 e

(* Compilação de uma instrução *)
let rec compile_instr = function
  | Set (x, e) ->
    Hashtbl.replace genv x ();
    compile_expr e ++
    popq rax ++
    movq (reg rax) (lab x)
  | Println e ->
    (* Print( Var(x) )*)
    compile_expr e ++
    popq rdi ++
    (* movq (imm i) (reg rdi) *)
    call "println_int"
  | Print e ->
    (* Print( Var(x) )*)
    compile_expr e ++
    popq rdi ++
    (* movq (imm i) (reg rdi) *)
    call "print_int"

  | Ifelse (e, i1, i2) ->
    lif := !lif + 1;
    let lif = !lif in
    compile_expr e ++ (*relational expr*)
    popq rax ++
    cmpq (imm 0) (reg rax) ++
    jne (Printf.sprintf ".if_true%d" lif) ++

    let code = List.map compile_instr i2 in
    let code = List.fold_left  (++) nop code in
    code ++
    jmp (Printf.sprintf ".if_end%d" lif) ++

    label ( Printf.sprintf ".if_true%d" lif) ++
      let code = List.map compile_instr i1 in
      let code = List.fold_left  (++) nop code in
      code ++
    
    label (Printf.sprintf ".if_end%d" lif) 

  | If (e, i) ->
    lif := !lif + 1;
    let lif = !lif in
    compile_expr e ++
    popq rax ++
    cmpq (imm 0) (reg rax) ++
    je (Printf.sprintf ".if_end%d" lif) ++
      label (Printf.sprintf ".if_true%d" lif) ++
        let code = List.map compile_instr i in
        let code = List.fold_left (++) nop code in
        code ++
    label (Printf.sprintf ".if_end%d" lif) 

(* Compila o programa p e grava o código no ficheiro ofile *)
let compile_program p ofile =
  let code = List.map compile_instr p in
  let code = List.fold_right (++) code nop in
  if !frame_size mod 16 = 8 then frame_size := 8 + !frame_size;
  let p =
    { text =
        globl "main" ++ label "main" ++
        pushq (reg rbp) ++
        movq (reg rsp) (reg rbp) ++
        subq (imm !frame_size) (reg rsp) ++
        code ++
        movq (imm 0) (reg rax) ++
        movq (reg rbp) (reg rsp) ++
        popq rbp ++
        ret ++
        label "println_int" ++
        pushq (reg rbp) ++
        movq (reg rdi) (reg rsi) ++
        leaq (lab ".Sprintln_int") rdi ++
        movq (imm 0) (reg rax) ++
        call "printf" ++
        popq rbp ++
        ret ++
        
        label "print_int" ++
        pushq (reg rbp) ++
        movq (reg rdi) (reg rsi) ++
        leaq (lab ".Sprint_int") rdi ++
        movq (imm 0) (reg rax) ++
        call "printf" ++
        popq rbp ++
        ret;
      data =
        Hashtbl.fold (fun x _ l -> label x ++ dquad [1] ++ l) genv
          (
            label ".Sprintln_int" ++ string "%d\n" ++
            label ".Sprint_int" ++ string "%d"
          )
    }
  in
  let f = open_out ofile in
  let fmt = formatter_of_out_channel f in
  X86_64.print_program fmt p;
  (*  "flush" do buffer para garantir que tudo fica escrito antes do fecho
       deste  *)
  fprintf fmt "@?";
  close_out f
