(* Sintaxe abstracta para a linguagem Arith *)

type program = stmt list

and stmt =
  | Declare of string * expr option
  | Set of string * expr
  | Println of expr
  | Print of expr
  | Read of string
  | If of expr * stmt list * stmt list
  | Control of ctrl
  | Do of stmt list
  | Whiledo of expr * stmt list
  | Dowhile of expr * stmt list
  | For of string * expr * expr * expr * stmt list

and expr =
  | Cst of int
  | Var of string
  | Binop of binop * expr * expr
  | Letin of string * expr * expr
  | Unop of unop * expr

and binop = Add | Sub | Mul | Div | Mod | Eq | Ge | Gt | Le | Lt | Ne | Or | And | Xor
and unop = Not (*| Inc | Dec*)
and ctrl = Exit | Continue
