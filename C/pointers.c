


#include <stdio.h>
#include <stdlib.h>

char* text1 = "This is a string.";
char* text2 = "Yet another thing.";
int* list1;
int* list2;
int count;


void printlist(const int* lst){
  printf("ASCII codes and corresponding characters.\n");
  while(*lst != 0){
    printf("0x%03X '%c' ", *lst, (char)*lst);
    lst++;
  }
  printf("\n");
}

void endian_proof(const char* c){

  //Each char is 8 bits so when we increment the memory we jump 8 bits

  printf("\nEndian experiment: 0x%02x,0x%02x,0x%02x,0x%02x\n", 
         (int)*c,(int)*(c+1), (int)*(c+2), (int)*(c+3));
}

void copycodes(char* str, int* toFill, int* count){

   while(*str != 0){

      *toFill=*str;
      toFill+=1;

      str++;
      *count+=1;

   }
}

void work(){
  const int size=80;
  
  list1 = (int*) malloc(size);
  list2 = (int*) malloc(size);

  count=0;

  copycodes(text1,list1,&count);
  copycodes(text2,list2,&count);

  free(list1);
  free(list2);
}



int main(void){
  work();

  printf("\nlist1: ");
  printlist(list1);
  printf("\nlist2: ");
  printlist(list2);
  printf("\nCount = %d\n", count);

  endian_proof((char*) &count);
}

/**
  
  Dereferencing - use * to go from pointer to value at that adress.
  Works like lb in MIPS.

  When incrementing pointer in C we increment by the size of its contents.
  As if we were iterating through an array.

  ASK!! 
    What is the difference between incrementing a pointer and incrementing a variable that a pointer points to? Explain how you your code is incrementing the count variable.

  Big or little endian - LITTLE!
  when we experimented with counter and set it to 350 we got the output
  0x5e,0x01,0x00,0x00
  350 in hex is 0x15e
  and we can see the most significant value is to the left. which means it's little endian.




*/
