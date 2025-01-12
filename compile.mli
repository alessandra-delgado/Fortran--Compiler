
exception VarUndef of string
  (** excepção levantada para assinalar uma variável não declarada *)

val compile_program : Ast.program -> string -> unit
  (** [compile_program p f] compila o programa [p] e escreve o código X86-64
      correspondente no ficheiro [f] *)

