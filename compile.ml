
(* Produção de código para a linguagem Arith *)

open Format
open X86_64
open Ast

(* Exceção por lançar quando uma variável (local ou global) é mal utilizada *)
exception VarUndef of string

(* Tamanho em byte da frame (cada variável local ocupa 8 bytes) *)
let frame_size = ref 0
let lbl = ref 

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
    | Binop (o, e1, e2)->
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

    | Letin (x, e1, e2) ->
        if !frame_size = next then frame_size := 8 + !frame_size;

        comprec env next e1 ++
        popq rax ++
        movq (reg rax) (ind ~ofs:(-next) rbp) ++
        
        comprec (StrMap.add x next env) (next + 8) e2
  in
  comprec StrMap.empty 0 e

(* Compilação de uma instrução *)
let compile_instr = function
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
      compile_expr e ++ 
      (*bruh i gotta do boolean type shit hold on*)
      nop


      
  | If (e, i) ->
      nop (*por implementar*)


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
