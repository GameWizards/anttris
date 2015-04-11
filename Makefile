CC=clang++
CXX=/opt/local/bin/clang++-mp-3.6
DEBUG=-g -Wall
CPP11=-std=c++11
CPP14=-std=c++14
OBJ=-c
GODOT_HEADLESS=linux_server-1.0devel.64
LINUX_OUTPUT=Anttris.bin
WINDOWS_OUTPUT=Anttris.exe

all: main

main: LINUX WINDOWS
	mkdir -p bin

LINUX:
	$(GODOT_HEADLESS) -path src -export "Linux X11" ../bin/$(LINUX_OUTPUT)

WINDOWS:
	$(GODOT_HEADLESS) -path src -export "Windows Desktop" ../bin/$(WINDOWS_OUTPUT)

clean:
	rm -rf bin
	mkdir -p bin
