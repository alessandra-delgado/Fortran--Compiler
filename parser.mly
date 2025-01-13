
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
%token ASSIGN
%token IF, THEN, ELSE, END
%token EQ, GE, GT, LE, LT, NE

/* Definição das prioridades e associatividades dos tokens */

%nonassoc IN
%left PLUS MINUS
%left TIMES DIV
%left EQ GE GT LE LT NE
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
| SET id = IDENT ASSIGN e = expr                                                  { Set (id, e) }
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
| LET id = IDENT ASSIGN e1 = expr IN e2 = expr
                                    { Letin (id, e1, e2) }
| LP e = expr RP                    { e }

;

%inline op:
| PLUS  { Add }
| MINUS { Sub }
| TIMES { Mul }
| DIV   { Div }
| EQ {Eq}
| NE { Ne }
| GT {Gt}
| GE {Ge}
| LT {Lt}
| LE {Le}
;



