

(* Lexer para Arith (modified hahaha) *)

{
  open Lexing
  open Parser

  exception Lexing_error of char
  exception Lexing_error_comment of string

  let kwd_tbl = ["let",LET; "in",IN; "set",SET; "print",PRINT; "println", PRINTLN; 
                 "if", IF; "then", THEN; "else", ELSE; "end", END;
                 "not", NOT; "or", OR; "and", AND; "xor", XOR; "mod", MOD;
                 "do", DO; "while", WHILE; "for", FOR;
                 "exit", EXIT; "continue", CONTINUE;
                 "read", READ]
  let id_or_kwd s = try List.assoc s kwd_tbl with _ -> IDENT s

}

let letter = ['a'-'z' 'A'-'Z']
let digit = ['0'-'9']
let ident = letter (letter | digit)*
let integer = ['0'-'9']+
let space = [' ' '\t']


rule token = parse
  | '\n'    { new_line lexbuf; token lexbuf }
  | "!*"              { comment lexbuf }
  | "!!" [^'\n']* '\n' { new_line lexbuf; token lexbuf }
  | space+  { token lexbuf }
  | ident as id { id_or_kwd id }
  | '+'     { PLUS }
  | '-'     { MINUS }
  | '*'     { TIMES }
  | '/'     { DIV }
  | '='     { ASSIGN }
  (* relational ------ *)
  | "=="    { EQ }
  | ">="    { GE }
  | '>'     { GT }
  | "<="    { LE }
  | '<'     { LT }
  | "!="    { NE }
  (* ------------------ *)
  | '('     { LP }
  | ')'     { RP }
  | ','     { CM }
  | ':'     { CL }
  | integer as s { CST (int_of_string s) }
  | eof     { EOF }
  | _ as c  { raise (Lexing_error c) }


and comment = parse
| eof                    { EOF }
| "*!" [^'\n']* '\n'     { new_line lexbuf; token lexbuf }
| '\n'                   { new_line lexbuf; comment lexbuf }
| _                      { comment lexbuf }

