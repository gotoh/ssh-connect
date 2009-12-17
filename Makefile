### Makefile 
###
### Create:   2009-12-17
### 

CC=gcc
CFLAGS=
LDLIBS=

## for Mac OS X environmet, use one of options
#CFLAGS=-DBIND_8_COMPAT=1
#LDLIBS=-lresolv

## for Solalis
#LDLIBS=-lresolv -lsocket -lnsl

all: connect

connect: connect.o
connect.o: connect.c

##

clean:
	rm -f connect.o *~
veryclean: clean
	rm -f connect
rebuild: veryclean all

### End of Makefile
