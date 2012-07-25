/*
Roman numerals to integer convertaur!
Requires:
	Regal 6.7 or whatever version

Grant Jones

Known Deficiencies:
	- does not enforce only powers of ten can be repeated (I X C M)
	- It does encorce a maximum of repetitions of any character to 3
	- limited input size of 1024
*/
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>


%%{
	machine romans_to_integer;
	write data;
}%%

static int64_t romans_to_integer( const char *str, uint32_t len, int *parse_err )
{
	// data pointer and data end pointers:
	const char *p = str, *pe = str + len;
	// current state:
	int cs;
	// accumulator:
	int64_t acc = 0;

	int repeat_count = 0;
	int repeat_char = 0;
	*parse_err = 0;

	%%{
		action finisheRepeatCheck {
			if( repeat_char == fc ) {
				repeat_count += 1;
				if( repeat_count >= 3) {
					*parse_err |= 0x2;
					fgoto error_out;
				}
			} else {
				repeat_char = fc;
				repeat_count = 0;
			}
		}
		action letterI { acc += 1; }
		action letterV { acc += 5; }
		action letterX { acc += 10; }
		action letterL { acc += 50; }
		action letterC { acc += 100; }
		action letterD { acc += 500; }
		action letterM { acc += 1000; }

		action subtractI { acc -= 1*2; }
		action subtractV { acc -= 5*2; }
		action subtractX { acc -= 10*2; }
		action subtractL { acc -= 50*2; }
		action subtractC { acc -= 100*2; }
		action subtractD { acc -= 500*2; }
		action subtractM { acc -= 1000*2; }
		

		subtractFromV = ('I' %subtractI ) 'V';
		subtractFromX = ('I' %subtractI | 'V' %subtractV ) 'X';
		subtractFromL = ('I' %subtractI | 'V' %subtractV | 'X' %subtractX ) 'L';
		subtractFromC = ('I' %subtractI | 'V' %subtractV | 'X' %subtractX | 'L' %subtractL ) 'C';
		subtractFromD = ('I' %subtractI | 'V' %subtractV | 'X' %subtractX | 'L' %subtractL | 'C' %subtractC ) 'D';
		subtractFromM = ('I' %subtractI | 'V' %subtractV | 'X' %subtractX | 'L' %subtractL | 'C' %subtractC | 'D' %subtractD ) 'M';

		error_out := ( any )*;
		main := ( 
			(
				(
					subtractFromV |
					subtractFromX |
					subtractFromL |
					subtractFromC |
					subtractFromD |
					subtractFromM |
					( 'I' %letterI ) |
					( 'V' %letterV ) |
					( 'X' %letterX ) |
					( 'L' %letterL ) |
					( 'C' %letterC ) |
					( 'D' %letterD ) |
					( 'M' %letterM ) 
				) %finisheRepeatCheck
			)+

			'\n'
		);

		# Initialize and execute.
		write init;
		write exec;
	}%%

	*parse_err |= ( cs < %%{ write first_final; }%% );

	return acc;
}

#define MAX_LINE_SIZE	1024

uint8_t *get_line( uint32_t *line_len ) {
	static uint8_t line[MAX_LINE_SIZE];
	uint32_t line_cur = 0;

	while( line_cur < MAX_LINE_SIZE && read(0, &line[line_cur], 1) == 1 ) {
		line_cur ++;
		if( line[line_cur-1] == '\n' ) {
			*line_len = line_cur;
			return line;
		}
	}
	if( line_cur > 0 ) {
		printf("Warning: adding newline so the parser works...\n");
		line[line_cur++] = '\n';
		*line_len = line_cur;
		return line;
	}
	return NULL;
}

int main( int argc, char *argv[] ) {
	uint32_t line_len;
	uint8_t *line;
	while( (line = get_line( &line_len )) != NULL ) {
		// we got a line, convert it:
		int parse_err = 0;
		int64_t value = romans_to_integer( line, line_len, &parse_err );
		
		// check if there was a conversion error:
		if( parse_err ) {
			printf("PARSE ERROR ON \"%.*s\"\n", line_len-1, line);
		} else {
			// no error
			printf("%lld\n", value);	
		}
	}
	
	return 0;
}

