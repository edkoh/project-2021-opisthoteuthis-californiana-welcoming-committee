all: config tetriminos tetris visualization tests

config: config.ml
	ocamlbuild -use-ocamlfind config.byte

tetriminos: tetriminos.ml
	ocamlbuild -use-ocamlfind tetriminos.byte

tetris: tetris.ml
	ocamlbuild -use-ocamlfind tetris.byte

visualization: visualization.ml
	ocamlbuild -use-ocamlfind visualization.byte

tests: tests.ml
	ocamlbuild -use-ocamlfind tests.byte
	
run:
	make all && ./tests.byte