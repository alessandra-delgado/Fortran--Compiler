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
module StrMap = Hashtbl.Make (String)

(* Compilação de uma expressão *)
let compile_expr env e =
  (* Função recursiva local de compile_expr utilizada para gerar o código
     máquina da árvore de sintaxe abstracta associada a um valor de tipo
     Ast.expr ; na sequência da execução deste código, o valor deve estar
     no topo da pilha *)
  let rec comprec env next e =
    match e with
    | Cst i -> pushq (imm i)
    | Var x -> (
        try
          let ofs = List.filter (fun e -> StrMap.mem e x) env in
          let ofs = StrMap.find (List.hd ofs) x in
          movq (ind ~ofs:(-ofs) rbp) (reg rax) ++ pushq (reg rax)
        with Not_found ->
          let _ = Hashtbl.find genv x in
          pushq (lab x))
    | Binop (((Div | Mod) as o), e1, e2) ->
        let register =
          match o with
          | Div -> rax
          | Mod -> rdx
          | _ -> failwith "Not implemented"
        in
        comprec env next e1 ++ comprec env next e2
        ++ movq (imm 0) (reg rdx)
        ++ popq rbx ++ popq rax
        ++ idivq (reg rbx)
        ++ pushq (reg register)
    | Binop (((Add | Sub | Mul) as o), e1, e2) ->
        let op =
          match o with
          | Add -> addq
          | Sub -> subq
          | Mul -> imulq
          | _ -> failwith "Not implemented"
        in

        comprec env next e1 ++ comprec env next e2 ++ popq rax ++ popq rbx
        ++ op (reg rax) (reg rbx)
        ++ pushq (reg rbx)
    | Binop (((Eq | Ne | Ge | Gt | Le | Lt | Xor) as o), e1, e2) ->
        let set =
          match o with
          | Eq -> sete
          | Ne | Xor -> setne
          | Ge -> setge
          | Gt -> setg
          | Le -> setle
          | Lt -> setl
          | _ -> failwith "Not implemented"
        in
        comprec env next e1 ++ comprec env next e2 ++ popq rax
        ++
        (*e2*)
        popq rbx
        ++
        (*e1*)
        cmpq (reg rax) (reg rbx)
        ++ set (reg al)
        ++ movzbq (reg al) rax
        ++ pushq (reg rax)
    | Binop (((Or | And) as o), e1, e2) ->
        let jump, value =
          match o with
          | Or -> (je, 1)
          | And -> (jne, 0)
          | _ -> failwith "Not implemented"
        in

        lbool := !lbool + 1;
        let lbool = !lbool in
        comprec env next e1 ++ popq rax
        ++ cmpq (imm 0) (reg rax)
        ++ jump (Printf.sprintf ".bool_condition%d" lbool)
        ++ pushq (imm value)
        ++ jmp (Printf.sprintf ".bool_end%d" lbool)
        ++ label (Printf.sprintf ".bool_condition%d" lbool)
        ++ comprec env next e2
        ++ label (Printf.sprintf ".bool_end%d" lbool)
    | Unop ((Not as o), e) ->
        let set = match o with Not -> sete in

        comprec env next e ++ popq rax
        ++ cmpq (imm 0) (reg rax)
        ++ set (reg al)
        ++ movzbq (reg al) rax
        ++ pushq (reg rax)
    | Letin (x, e1, e2) ->
        if !frame_size = next then frame_size := 8 + !frame_size;

        (* Create new environment *)
        let t = StrMap.create 8 in
        StrMap.add t x next;
        comprec env next e1 ++ popq rax
        ++ movq (reg rax) (ind ~ofs:(-next) rbp)
        ++ comprec (t :: env) (next + 8) e2
  in
  comprec env !frame_size e

(* Instruction compiling *)
let compile_instr env inst =
  let rec comprec env inst =
    match inst with
    | Declare (x, e) ->
        (* Increment frame size for storing variable address in stack*)

        (* 1 - Search if variable exists in the current environment. *)
        (* Note: You can redeclare a variable, even if it is declared in surrounding environments,
          but never if it's already declared in the current one. *)
        let _ =
          match env with
          | hd :: _ -> (
              try
                let _ = StrMap.find hd x in
                failwith (Printf.sprintf "Redefinition of variable '%s'" x)
              with Not_found -> StrMap.add hd x !frame_size)
          | [] -> failwith "No scope declared."
        in

        (* 2 - Check if there is value to atribute to variable *)
        let code =
          match e with
          | Some expr ->
              (* Compile expression using the new environment *)
              compile_expr env expr ++ popq rax
              ++ movq (reg rax) (ind ~ofs:(- !frame_size) rbp)
          | None ->
              (*It is not required to atribute a value right away*)
              nop
        in
        frame_size := 8 + !frame_size;
        code
    | Set (x, e) -> (
        (* 1 - Search for variable in all active environments, prioritizing the nearest *)
        try
          let ofs = List.filter (fun e -> StrMap.mem e x) env in
          let ofs = StrMap.find (List.hd ofs) x in
          compile_expr env e ++ popq rax ++ movq (reg rax) (ind ~ofs:(-ofs) rbp)
        with Not_found ->
          failwith
            (Printf.sprintf "Variable '%s' is not declared in the scope." x))
    | Println e ->
        (* Print( Var(x) )*)
        compile_expr env e ++ popq rdi
        ++
        (* movq (imm i) (reg rdi) *)
        call "println_int"
    | Print e ->
        (* Print( Var(x) )*)
        compile_expr env e ++ popq rdi
        ++
        (* movq (imm i) (reg rdi) *)
        call "print_int"
    | Read x -> (
        (* You can only replace a variable's value if it exists in the nearest scope. *)
        (* 1 - Search *)
        (* Map find function for all maps in env *)
        try
          let ofs = List.map (fun e -> StrMap.find e x) env in
          let ofs = List.hd ofs in
          leaq (ind ~ofs:(-ofs) rbp) rsi ++ call "read_int"
        with Not_found ->
          failwith
            (Printf.sprintf "Variable '%s' is not declared in the scope." x)
          (* todo: fix everything below :'3 *))
    | If (e, i1, i2) ->
        lif := !lif + 1;
        let lif = !lif in
        let else_block =
          match i2 with
          | [] ->
              (*no else statement: if condition is false jump to end *)
              je (Printf.sprintf ".if_end%d" lif)
          | _ ->
              (*if the else statement is specified, compile the correspondent code*)
              jne (Printf.sprintf ".if_true%d" lif)
              ++
              let code = List.map (comprec (StrMap.create 8 :: env)) i2 in
              let code = List.fold_left ( ++ ) nop code in
              code ++ jmp (Printf.sprintf ".if_end%d" lif)
        in

        (* main condition *)
        compile_expr env e
        ++
        (*relational expr *)
        popq rax
        ++ cmpq (imm 0) (reg rax)
        ++ else_block
        ++ label (Printf.sprintf ".if_true%d" lif)
        ++
        (* compile code for true condition in a new environment *)
        let code = List.map (comprec (StrMap.create 8 :: env)) i1 in
        let code = List.fold_left ( ++ ) nop code in
        code ++ label (Printf.sprintf ".if_end%d" lif)
    | Do b ->
        let t = StrMap.create 8 in
        lloop := !lloop + 1;
        let lloop = !lloop in

        label (Printf.sprintf ".do_begin%d" lloop)
        ++
        (* executes code block infinitely *)
        let code = List.map (comprec (t :: env)) b in
        let code = List.fold_left ( ++ ) nop code in
        code
        ++ jmp (Printf.sprintf ".do_begin%d" lloop)
        ++ label (Printf.sprintf ".do_exit%d" lloop)
    | Whiledo (e, b) ->
        let t = StrMap.create 8 in
        lloop := !lloop + 1;
        let lloop = !lloop in

        label (Printf.sprintf ".do_begin%d" lloop)
        (* compile stop condition *)
        ++ compile_expr env e
        ++ popq rax
        ++ cmpq (imm 0) (reg rax)
        (* if its result's false, exit the loop *)
        ++ je (Printf.sprintf ".do_exit%d" lloop)
        ++
        let code = List.map (comprec (t :: env)) b in
        let code = List.fold_left ( ++ ) nop code in
        code
        ++ jmp (Printf.sprintf ".do_begin%d" lloop)
        ++ label (Printf.sprintf ".do_exit%d" lloop)
    | Dowhile (e, b) ->
        lloop := !lloop + 1;
        let lloop = !lloop in

        label (Printf.sprintf ".do_begin%d" lloop)
        ++
        (* executes code block at least once *)
        let code = List.map (comprec (StrMap.create 8 :: env)) b in
        let code = List.fold_left ( ++ ) nop code in
        code ++ compile_expr env e ++ popq rax
        ++ cmpq (imm 0) (reg rax)
        (* verifies condition state after executing code block, exits if false *)
        ++ jne (Printf.sprintf ".do_begin%d" lloop)
        ++ label (Printf.sprintf ".do_exit%d" lloop)
    | For (i, e, c, u, block) ->
        let t = StrMap.create 8 in
        lloop := !lloop + 1;
        let lloop = !lloop in
        (* 1- In a for loop, the variable 'i' is inserted into the new environment *)
        let i_ofs = !frame_size in
        StrMap.add t i i_ofs;
        let n_env = t :: env in
        frame_size := 8 + !frame_size;

        (* 2 - Compile the expression in current environment *)
        compile_expr n_env e ++ popq rax
        ++ movq (reg rax) (ind ~ofs:(-i_ofs) rbp)

        (* 3 - For body *)
        ++ label (Printf.sprintf ".do_begin%d" lloop)
        (* Compile condition *)
        ++ movq (ind ~ofs:(-i_ofs) rbp) (reg rbx) (* i value *)
        ++ compile_expr n_env c
        ++ popq rax (* end value*)
        ++ cmpq (reg rax) (reg rbx) (* if i is greater or equal to end value, jump to exit*)
        ++ jge (Printf.sprintf ".do_exit%d" lloop)
        ++
        (* While condition true *)
        let code = List.map (comprec n_env) block in
        let code = List.fold_left ( ++ ) nop code in
        code
        ++
        (* 4 - Step update on i *)
        compile_expr env u ++ popq rax
        ++ movq (ind ~ofs:(-i_ofs) rbp) (reg rbx)
        ++ addq (reg rax) (reg rbx)
        ++ movq (reg rbx) (ind ~ofs:(-i_ofs) rbp)
        ++ jmp (Printf.sprintf ".do_begin%d" lloop)
        ++ label (Printf.sprintf ".do_exit%d" lloop)
    | Control c -> (
        match c with
        | Exit -> jmp (Printf.sprintf ".do_exit%d" !lloop)
        | Continue -> jmp (Printf.sprintf ".do_begin%d" !lloop))
  in

  comprec env inst

(* Compila o programa p e grava o código no ficheiro ofile *)
let compile_program p ofile =
  let code = List.map (compile_instr [ StrMap.create 8 ]) p in
  let code = List.fold_right ( ++ ) code nop in
  if !frame_size mod 16 = 8 then frame_size := 8 + !frame_size;
  let p =
    {
      text =
        globl "main" ++ label "main"
        ++ pushq (reg rbp)
        ++ movq (reg rsp) (reg rbp)
        ++ subq (imm !frame_size) (reg rsp)
        ++ code
        ++ movq (imm 0) (reg rax)
        ++ movq (reg rbp) (reg rsp)
        ++ popq rbp ++ ret ++ label "println_int"
        ++ pushq (reg rbp)
        ++ movq (reg rdi) (reg rsi)
        ++ leaq (lab ".Sprintln_int") rdi
        ++ movq (imm 0) (reg rax)
        ++ call "printf" ++ popq rbp ++ ret ++ label "print_int"
        ++ pushq (reg rbp)
        ++ movq (reg rdi) (reg rsi)
        ++ leaq (lab ".Sprint_int") rdi
        ++ movq (imm 0) (reg rax)
        ++ call "printf" ++ popq rbp ++ ret ++ label "read_int"
        ++ pushq (reg rbp)
        ++ leaq (lab ".Sprint_int") rdi
        ++ movq (imm 0) (reg rax)
        ++ call "scanf" ++ popq rbp ++ ret;
      data =
        Hashtbl.fold
          (fun x _ l -> label x ++ dquad [ 1 ] ++ l)
          genv
          (label ".Sprintln_int" ++ string "%ld\n" ++ label ".Sprint_int"
         ++ string "%ld");
    }
  in
  let f = open_out ofile in
  let fmt = formatter_of_out_channel f in
  X86_64.print_program fmt p;
  (*  "flush" do buffer para garantir que tudo fica escrito antes do fecho
       deste  *)
  fprintf fmt "@?";
  close_out f
