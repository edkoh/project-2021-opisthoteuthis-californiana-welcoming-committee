all: config tetromino tetris vis tests controller

config: config.ml
	ocamlbuild -use-ocamlfind config.byte

tetromino: tetromino.ml
	ocamlbuild -use-ocamlfind tetromino.byte

tetris: tetris.ml
	ocamlbuild -use-ocamlfind tetris.byte

vis: visualization.ml
	ocamlbuild -use-ocamlfind visualization.byte

tests: tests.ml
	ocamlbuild -use-ocamlfind tests.byte

controller: controller.ml
	ocamlbuild -use-ocamlfind controller.byte
	
run:
	make all && ./tetris.byte