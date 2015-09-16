
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define COLUMNS 6

int printedNumbersInRow=0;

//AUTHOR: IVAN LILJEQVIST 
void print_number(int n){

  printf("%10d ", n);
  
  printedNumbersInRow++;

  if(printedNumbersInRow>=COLUMNS){
    printf("\n");
    printedNumbersInRow=0;
  } 
}

/*

PSEUDOCODE FROM WIKIPEDIA:

Input: an integer n > 1
 
Let A be an array of Boolean values, indexed by integers 2 to n,
initially all set to true.
 
 for i = 2, 3, 4, ..., not exceeding √n:
  if A[i] is true:
    for j = i2, i2+i, i2+2i, i2+3i, ..., not exceeding n :
      A[j] := false
 
Output: all i such that A[i] is true.*/

//AUTHOR: IVAN LILJEQVIST 

void print_sieves(int n){
    int i;
    
    /**
      make an array filled with TRUE that can hold indexes up to n
      we dont want the first two elements 0 and 1 because the algorithm starts at 2.
      therefore we dont allocate memory for that. instead we have (n+1)-2=n-1
      */

    int A[n-1];

    //set all elements to true (1)
    for(i=0;i<n;i++){
        A[i]=1;
    }
    
    //Implemented algorithm from pseudo code
    for(i=2;i<=sqrt(n);i++){
        if(A[i-2]){
            int j;
            for (j = i*i; j<=n;j+=i)
            {
               A[j-2]=0;
            }
        }
    }

    for(i=2;i<n;i++){
        if(A[i-2]){
            print_number(i);
        }
    }

    printf("\n");
    printf("Sive of A: %lu",sizeof(A));
    printf("\n");
}

// 'argc' contains the number of program arguments, and
// 'argv' is an array of char pointers, where each
// char pointer points to a null-terminated string.
int main(int argc, char *argv[]){
  if(argc == 2)
    print_sieves(atoi(argv[1]));
  else
    printf("Please state an interger number.\n");
  return 0;
}


