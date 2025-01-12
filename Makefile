all:
	@dune build ./_build/default/main.exe 

exec:
	@dune exec ./_build/default/main.exe ./teste.exp
	@gcc -g -no-pie teste.s && ./a.out

clean:
	dune clean