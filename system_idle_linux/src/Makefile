all:
	mkdir -p ../dist
	g++ -fPIC ffi_api.cpp -c -o ffi_api.o
	g++ -fPIC ffi_api.o -shared -o ../dist/system_idle_linux.so -lxcb -lxcb-screensaver

# test: all
# 	g++ main.cpp -c main.o
# 	g++ main.o

clean:
	rm -f *.o ../dist/*.so
