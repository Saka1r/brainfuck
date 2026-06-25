
default: build

.PHONY: build
build:
	nasm -f elf64 bf.asm -o bf.o
	ld bf.o -o bf

.PHONY: run
run: build
	./bf

.SILENT: clean
.PHONY: clean
clean:
	rm -rf bf.o
	rm -rf bf
