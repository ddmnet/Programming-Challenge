//
//  main.m
//  RomanNumeralConversionC
//
//  Created by Kris Utter on 7/24/12.
//  Copyright (c) 2012 ddm. All rights reserved.
//

#include <stdio.h>
#include <string.h>

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // loop through a string using a subscript 
        BOOL invalid = FALSE;
        char source[100];
        scanf("%s", &source );
        
        int length = (int)strlen(source);
        int array[length];
        int total = 0;
        for (int i = 0; i < length; i++) 
        {
            //I = 1, V = 5, X = 10, L = 50, C = 100, D = 500, M = 1000
            if (source[i] == 'M') {
                array[i] = 1000;
            } else if (source[i] == 'D') {
                array[i] = 500;
            } else if (source[i] == 'C') {
                array[i] = 100;
            } else if (source[i] == 'L') {
                array[i] = 50;
            } else if (source[i] == 'X') {
                array[i] = 10;
            } else if (source[i] == 'V') {
                array[i] = 5;
            } else if (source[i] == 'I') {
                array[i] = 1;
            } else {
                invalid = TRUE;
            }
        }  
        int arrayLength = sizeof(array)/sizeof(int);
        for (int i = 0; i < arrayLength; i++) 
        {
            if(i == 0){
                total = total + array[i];
            } else {
                if (i == 1) {
                    if (array[i] < array[i + 1]) {
                        total = total ;
                    } 
                }
                if(array[i-1] < array[i]){
                    total = total + array[i] - array[i -1] * 2;
                } else {
                    total = total + array[i];
                }
            }
        }
        if (invalid) {
            printf("Ceasar says 'What strange dialect is this! Invalid Character for Roman Numerals. You shall be fed to the lions'.");
        } else {
            printf("Ceasar says 'The number you seek is.....%i'", total);
        }
        
        
    }
    return 0;
}

