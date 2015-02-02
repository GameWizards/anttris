CC=clang++
CXX=/opt/local/bin/clang++-mp-3.6
DEBUG=-g -Wall
CPP11=-std=c++11
CPP14=-std=c++14
OBJ=-c

all: main

main:
	$(CC) $(CPP14) src/hello.cc -o bin/hello
