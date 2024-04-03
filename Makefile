all:
	v -prod -fast-math ./src/ -o rt.exe
	./rt.exe 500 500 10

comp:
	v -prod -fast-math ./src/ -o rt.exe

big:
	v -prod -fast-math ./src/ -o rt.exe
	./rt.exe 1920 1200 10

debug:
	v run ./src/ 200 200 10