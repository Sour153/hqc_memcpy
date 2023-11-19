CC = gcc
# CFLAGS = -O2 -fopenmp 
CFLAGS = -O2 

all:  memcpy

memcpy: memcpy.c
	$(CC) $(CFLAGS) memcpy.c mysecond.c -o memcpy


clean:
	rm -f memcpy *.o