(* Sintaxe abstracta *)

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
  | Numop of sunop * string

and expr =
  | Cst of int
  | Var of string
  | Binop of binop * expr * expr
  | Letin of string * expr * expr
  | Unop of eunop * expr


and ctrl = Exit | Continue
and binop = Add | Sub | Mul | Div | Mod | Eq | Ge | Gt | Le | Lt | Ne | Or | And | Xor
(* Expression unary op*)
and eunop = Not
(* Statement unary ops *)
and sunop = Inc | Dec 