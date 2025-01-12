
/* parser para  Arith */

%{
  open Ast
%}

%token <int> CST
%token <string> IDENT
%token SET, LET, IN, PRINT, PRINTLN
%token EOF
%token LP RP
%token PLUS MINUS TIMES DIV
%token EQ
%token IF, THEN, ELSE, END
%token EQQ, BEQ, BT, LEQ, LT, NOT

/* Definição das prioridades e associatividades dos tokens */

%nonassoc IN
%left PLUS MINUS
%left TIMES DIV
%nonassoc uminus

/* Ponto de entrada da gramática */
%start prog

/* Tipo dos valores devolvidos pelo parser */
%type <Ast.program> prog

%%

prog:
| p = stmts EOF { List.rev p }
;

stmts:
| i = stmt           { [i] }
| l = stmts i = stmt { i :: l }
;

stmt:
| SET id = IDENT EQ e = expr                                                  { Set (id, e) }
| PRINT e = expr                                                              { Print e }
| PRINTLN LP e = expr RP                                                      { Println e }
| IF e = expr THEN block1 = list(stmt) ELSE block2 = list(stmt) END IF      {Ifelse (e, block1, block2)}
| IF e = expr THEN block = list(stmt) END IF                                {If (e, block)}
;

expr:
| c = CST                           { Cst c }
| id = IDENT                        { Var id }
| e1 = expr o = op e2 = expr        { Binop (o, e1, e2) }
| MINUS e = expr %prec uminus       { Binop (Sub, Cst 0, e) }
| LET id = IDENT EQ e1 = expr IN e2 = expr
                                    { Letin (id, e1, e2) }
| LP e = expr RP                    { e }
| e1 = expr  o = bool_op e2 = expr  { Boolop (o, e1, e2)}

;

%inline op:
| PLUS  { Add }
| MINUS { Sub }
| TIMES { Mul }
| DIV   { Div }
;

%inline bool_op:
| EQQ {Eq}
| BEQ {Beq}
| BT {Bt}
| LEQ {Leq}
| LT {Lt}
| NOT {Not}
;



