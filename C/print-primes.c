/*
 print-prime.c
 By David Broman.
 Last modified: 2015-09-15
 This file is in the public domain.
*/


#include <stdio.h>
#include <stdlib.h>

#define COLUMNS 6


int printedNumbersInRow=0;

//AUTHOR: IVAN LILJEQVIST 
int is_prime(int n){
    int i;
    int res = 1;

    for(i=2;i<n;i++){
        //If modulu is 0, it was possible to divide by 0 and it's not a prime.
        if(n%i==0){
            res=0;
            break;
        }
    }

    return res;
}

//AUTHOR: IVAN LILJEQVIST 
void print_number(int n){

  printf("%10d ", n);
  
  printedNumbersInRow++;

  if(printedNumbersInRow>=COLUMNS){
    printf("\n");
    printedNumbersInRow=0;
  }

  
}

//IVAN LILJEQVIST WROTE THIS
void print_primes(int n){
  // Should print out all prime numbers less than 'n'
  // with the following formatting. Note that
  // the number of columns is stated in the define
  // COLUMNS

  int i=2;
  while(i<=n){
    if(is_prime(i)){
      print_number(i);
    }
    i++;
  }

  printf("\n");

}

// 'argc' contains the number of program arguments, and
// 'argv' is an array of char pointers, where each
// char pointer points to a null-terminated string.
int main(int argc, char *argv[]){
  if(argc == 2)
    print_primes(atoi(argv[1]));
  else
    printf("Please state an interger number.\n");
  return 0;
}

 
