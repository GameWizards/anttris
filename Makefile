CC=clang++
CXX=/opt/local/bin/clang++-mp-3.6
DEBUG=-g -Wall
# CPP11=-std=c++11
# CPP14=-std=c++1y
OBJ=-c

all: prep main

prep:
	mkdir bin

main:
	$(CC) $(CPP14) src/hello.cc -o bin/hello
