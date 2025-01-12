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
  | Boolop of boolop * expr * expr

and binop = Add | Sub | Mul | Div
and boolop = Eq | Beq | Bt | Leq | Lt | Not
