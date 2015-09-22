/*
 prime.c
 By David Broman.
 Last modified: 2015-09-15
 This file is in the public domain.

 Ivan Liljeqvist
*/


#include <stdio.h>

int is_prime(int n){
    int i;
    int res = 1;

    for(i=2;i<n;i++){
        //If modulu is 0 we have successfuly divided the number by a number between 2 and n. Then it is not a prime.
        if(n%i==0){
            res=0;
            break;
        }
    }

    return res;
}

int main(void){
    printf("%d\n", is_prime(11));  // 11 is a prime.      Should print 1.
    printf("%d\n", is_prime(383)); // 383 is a prime.     Should print 1.
    printf("%d\n", is_prime(987)); // 987 is not a prime. Should print 0.
}

