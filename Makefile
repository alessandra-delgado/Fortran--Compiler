all:

	@dune build ./_build/default/main.exe 
	@dune exec ./_build/default/main.exe ./teste.fmm
	@gcc -g -no-pie teste.s && ./a.out

clean:
	dune clean