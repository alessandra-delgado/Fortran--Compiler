
/* parser para  Arith */

%{
  open Ast
%}

%token <int> CST
%token <string> IDENT
%token SET, LET, IN, PRINT, PRINTLN, READ
%token EOF
%token LP RP END
%token PLUS MINUS TIMES DIV MOD
%token ASSIGN
%token IF, THEN, ELSE
%token EQ, GE, GT, LE, LT, NE
%token AND, OR, XOR, NOT
%token DO, WHILE
%token EXIT, CONTINUE


/* Definição das prioridades e associatividades dos tokens */

%nonassoc IN
%left PLUS MINUS
%left TIMES DIV MOD
%left NOT OR AND XOR EQ GE GT LE LT NE
%nonassoc uminus

/* Ponto de entrada da gramática */
%start prog

/* Tipo dos valores devolvidos pelo parser */
%type <Ast.program> prog

%%

prog:
| p = list (stmts) EOF                                                               { p }
;

stmts:
| i = stmt                                                                    { i }
;

stmt:
| SET id = IDENT ASSIGN e = expr                                              { Set (id, e) }
| PRINT LP e = expr RP                                                        { Print e }
| PRINTLN LP e = expr RP                                                      { Println e }
| READ LP id = IDENT RP                                                       { Read id }
| IF e = expr THEN block = list(stmt) ei = els END IF                         { If (e, block, ei) }
| DO block = list(stmt) END DO                                                { Do (block) }
| DO WHILE LP e = expr RP block = list(stmt) END DO                           { Whiledo (e, block) }
| DO block = list(stmt) WHILE LP e = expr RP END DO                           { Dowhile (e, block) }
| c = ctrl                                                                    { Control c }
;

els:
| ELSE block = list(stmt)                                                     { block }
|                                                                             { [] }
;

expr:
| c = CST                                                                     { Cst c }
| id = IDENT                                                                  { Var id }
| e1 = expr o = op e2 = expr                                                  { Binop (o, e1, e2) }
| MINUS e = expr %prec uminus                                                 { Binop (Sub, Cst 0, e) }
| LET id = IDENT ASSIGN e1 = expr IN e2 = expr                                { Letin (id, e1, e2) }
| LP e = expr RP                                                              { e }
| o = uop e = expr                                                            { Unop (o, e) }

;

%inline op:
| PLUS                                                                        { Add }
| MINUS                                                                       { Sub }
| TIMES                                                                       { Mul }
| DIV                                                                         { Div }
| MOD                                                                         { Mod }
| EQ                                                                          { Eq }
| NE                                                                          { Ne }
| GT                                                                          { Gt }
| GE                                                                          { Ge }
| LT                                                                          { Lt }
| LE                                                                          { Le }
| OR                                                                          { Or }
| AND                                                                         { And }
| XOR                                                                         { Xor }
;

%inline uop:
| NOT                                                                         { Not }
;

%inline ctrl:
| EXIT                                                                        { Exit }
| CONTINUE                                                                    { Continue }
;