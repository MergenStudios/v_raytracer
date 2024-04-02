all:
	v -prod -fast-math ./src/ -o rt.exe
	./rt.exe 500 500 500