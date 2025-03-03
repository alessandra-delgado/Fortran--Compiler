(* Ficheiro principal do compilador arithc *)

open Format
open Lexing

(* Opção de compilação, para parar na fase de parsing *)
let parse_only = ref false

(* Nome dos ficheiros fonte e alvo *)
let ifile = ref ""
let ofile = ref ""
let set_file f s = f := s

(* As opções do compilador que são mostradas quando é invocada o comando arithc --help *)
let options =
  [
    ("-parse-only", Arg.Set parse_only, "  Executar somente o parsing");
    ( "-o",
      Arg.String (set_file ofile),
      "<file>  Para indicar o nome do ficheiro em saída" );
  ]

let usage = "usage: arithc [option] file.fmm"

(* localiza um erro indicando a linha e a coluna *)
let localisation pos =
  let l = pos.pos_lnum in
  let c = pos.pos_cnum - pos.pos_bol + 1 in
  eprintf "File \"%s\", line %d, characters %d-%d:\n" !ifile l (c - 1) c

let () =
  (* Parsing da linha de comando *)
  Arg.parse options (set_file ifile) usage;

  (* Verifica-se que o nome do ficheiro fonte foi bem introduzido *)
  if !ifile = "" then (
    eprintf "Nenhum ficheiro para compilar\n@?";
    exit 1);

  (* Este ficheiro deve ter como extensão  .fmm *)
  if not (Filename.check_suffix !ifile ".fmm") then (
    eprintf "O ficheiro em entrada deve ter a extensão .fmm\n@?";
    Arg.usage options usage;
    exit 1);

  (* Por omissão, o ficheiro alvo tem o mesmo nome que o ficheiro fonte,
     só muda a extensão *)
  if !ofile = "" then ofile := Filename.chop_suffix !ifile ".fmm" ^ ".s";

  (* Abertura do ficheiro fonte em leitura *)
  let f = open_in !ifile in

  (* Criação do buffer de análise léxica *)
  let buf = Lexing.from_channel f in

  try
    (* Parsing: A função Parser.prog transforma o buffer d'análise léxica
       numa árvore de sintaxe abstracta se nenujk erro  (léxico ou sintáctico)
       foi detectado.
       A função Lexer.token é utilizada por Parser.prog para obter
       o próximo token. *)
    let p = Parser.prog Lexer.token buf in
    close_in f;

    (* Pára-se aqui se só queremos o parsing *)
    if !parse_only then exit 0;

    (* Compilação da árvore de sintaxe abstracta p. O código máquina
       resultante desta transformação deve ficar escrito no ficheiro alvo ofile. *)
    Compile.compile_program p !ofile
  with
  | Lexer.Lexing_error c ->
      (* Erro léxico. Recupera-se a posição absoluta e converte-se para número
           de linha *)
      localisation (Lexing.lexeme_start_p buf);
      eprintf "Erro durante a análise léxica: %c@." c;
      exit 1
  | Lexer.Lexing_error_comment s ->
      (* Erro léxico. Recupera-se a posição absoluta e converte-se para número
  de linha *)
      localisation (Lexing.lexeme_start_p buf);
      eprintf "Erro durante a análise léxica: %s@." s;
      exit 1
  | Parser.Error ->
      (* Erro sintáctio. Recupera-se a posição e converte-se para número
           de linha *)
      localisation (Lexing.lexeme_start_p buf);
      eprintf "Erro durante a análise sintáctica@.";
      exit 1
  | Compile.VarUndef s ->
      (* Erro de utilização de variáveis durante a compilação *)
      eprintf "Erro de compilação: a variável  %s não está definida@." s;
      exit 1
