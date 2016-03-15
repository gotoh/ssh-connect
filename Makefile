### Makefile 
###
### Create:   2009-12-17
### Updated:  2012-06-21
### 

ifeq ($(OS), Windows_NT)
    WINVER := $(shell ver)
else
    UNAME := $(shell uname -s)
endif

CC=gcc
CFLAGS=
LDLIBS=

## for Mac OS X environment, use one of options
ifeq ($(UNAME), Darwin)
	CFLAGS=-DBIND_8_COMPAT=1
	LDLIBS=-lresolv
endif

## for Solaris
ifeq ($(UNAME), SunOS)
	LDLIBS=-lresolv -lsocket -lnsl
endif

## for Microsoft Windows native
ifeq ($(findstring Windows, ${WINVER}), Windows)
    ifeq (${CC}, clang)
	CFLAGS=-ccc-gcc-name llvm-gcc.exe
	LDLIBS=-ccc-gcc-name llvm-gcc.exe
    endif
    LDLIBS := ${LDLIBS} -lws2_32 -liphlpapi
endif

all: connect

connect: connect.o
connect.o: connect.c

##

clean:
	rm -f connect.o *~
veryclean: clean
	rm -f connect connect.exe
rebuild: veryclean all

### End of Makefile
