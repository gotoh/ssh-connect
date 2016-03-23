### Makefile 
###
### Create:   2009-12-17
### Updated:  2012-06-21
### 

ifeq ($(OS), Windows_NT)
    UNAME := Windows
else
    UNAME := $(shell uname -s)
endif

CC=gcc
CFLAGS=-DSOCKLEN_T=int
LDLIBS=

## for Mac OS X environment, use one of options
ifeq ($(UNAME), Darwin)
	CFLAGS=-DBIND_8_COMPAT=1 -DSOCKLEN_T=socklen_t
	LDLIBS=-lresolv
endif

## for Solaris
ifeq ($(UNAME), SunOS)
	LDLIBS=-lresolv -lsocket -lnsl
endif

## for Microsoft Windows native
ifeq ($(UNAME), Windows)
    ifeq (${CC}, clang)
	CFLAGS+=-ccc-gcc-name llvm-gcc.exe
	LDLIBS+=-ccc-gcc-name llvm-gcc.exe
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
