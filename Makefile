### Makefile 
###
### Create:   2009-12-17
### Updated:  2012-06-21
### 

UNAME := $(shell uname -s)

CC=gcc
CFLAGS=
LDLIBS=

## for Mac OS X environmet, use one of options
ifeq ($(UNAME), Darwin)
	CFLAGS=-DBIND_8_COMPAT=1
	LDLIBS=-lresolv
endif

## for Solalis
ifeq ($(UNAME), SunOS)
	LDLIBS=-lresolv -lsocket -lnsl
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
