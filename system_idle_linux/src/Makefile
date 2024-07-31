all:
	mkdir -p ../dist
	g++ -fPIC system_idle_linux.cpp -c -o system_idle_linux.o
	g++ -fPIC system_idle_linux.o -shared -o ../dist/system_idle_linux.so -lxcb -lxcb-screensaver

clean:
	rm -f *.o ../dist/*.so
