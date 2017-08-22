all:
	jbuilder build @install @runtest 
clean:
	rm -rf _build
pin:
	opam remove letchain && opam pin add letchain . -n && opam install letchain