/*
gcc grant.c -o grant -O3
Reverses doc. Brute-force like and in ASCII because american english is the only language that matters.
*/
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <fcntl.h>
#include <signal.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <sys/time.h>

#define IS_WHITE_SPACE(x) ( (x) == ' ' || (x) == '\n' || (x) == '\r' )

static int reverse = 0;
static void user_done_irqd( int sig ) {
	reverse = 1;
}

double getTime()
{
	struct timeval t;
	gettimeofday(&t, NULL);
	return ((double)t.tv_sec * 1000000.0 + (double)t.tv_usec) / 1000000.0;
} 

void reverse_word( uint8_t *start, uint32_t sz ) {
	uint32_t x;
	for( x = 0; x < sz/2; x ++ ) {
		uint8_t c = start[x];
		start[x] = start[sz - x - 1];
		start[sz - x - 1] = c;
	}
	// printf(". %.*s\n", sz, start);
}

uint32_t reverse_doc( uint8_t *mem, uint32_t sz ) {
	uint32_t x, y;
	uint32_t last_known_pos = -1;
	for( x = 0; x < sz && !reverse; x ++ ) {
		for( y = x; y < sz && !IS_WHITE_SPACE(mem[y]); y ++ );
		reverse_word( &mem[x], y - x );
		x += (y - x);
		last_known_pos = x;
	}
	return last_known_pos;
}

int main( int argc, char *argv[] ) {
	signal( SIGINT, user_done_irqd );
	if( argc != 2 ) {
		printf("usage:\n\t%s [input file]\n", argv[0]);
		return -1;
	}
	int fd = open( argv[1], O_RDWR );
	if( fd < 0 ) {
		return -1;
	}
	struct stat st;
	if( fstat( fd, &st) < 0 ) {
		return -1;
	}

	printf("file size is %lld\n", st.st_size );
	uint8_t *mem = mmap(NULL, st.st_size, PROT_READ | PROT_WRITE, MAP_FILE | MAP_SHARED, fd, 0);
	if( mem == MAP_FAILED ) {
		return -1;
	}
	double start_time = getTime();
	uint32_t lkp = reverse_doc( mem, st.st_size );
	printf("reverse time: %f s\n", getTime() - start_time);
	if( reverse ) {
		printf("undoing reverse!");
		reverse = 0;
		start_time = getTime();
		reverse_doc( mem, lkp );
		printf("unreverse time: %f s\n", getTime() - start_time);
	}
	munmap(mem, st.st_size);
	close(fd);
	return 0;
}