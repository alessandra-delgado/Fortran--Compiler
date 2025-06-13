all:

	@dune build ./_build/default/main.exe 
	@dune exec ./_build/default/main.exe ./teste.fmm #< replace for your file's path
	@gcc -g -no-pie teste.s && ./a.out

clean:
	dune clean