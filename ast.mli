(* Sintaxe abstracta para a linguagem Arith *)

type program = stmt list

and stmt =
  | Set of string * expr
  | Println of expr
  | Print of expr
  | Ifelse of expr * stmt list * stmt list
  | If of expr * stmt list

and expr =
  | Cst of int
  | Var of string
  | Binop of binop * expr * expr
  | Letin of string * expr * expr
  | Unop of unop * expr

and binop = Add | Sub | Mul | Div | Mod | Eq | Ge | Gt | Le | Lt | Ne | Or | And | Xor
and unop = Not
