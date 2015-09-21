/* main.c

   This file written 2015 by F Lundevall and David Broman

   Latest update 2015-09-15 by David Broman

   For copyright and licensing, see file COPYING */

#include <stddef.h>   /* Declarations of integer sizes and the like, part 1 */
#include <stdint.h>   /* Declarations of integer sizes and the like, part 2 */
#include <pic32mx.h>  /* Declarations of system-specific addresses etc */

void saveinfo(char s[], void * a, size_t ns );
void showinfo(void);
void u32init(void);

int gv; /* Global variable. */
int in = 3; /* Global variable, initialized to 4711. */

void fun(int param)
{
  param++;
  saveword( "AF1: param", &param );
  gv = param; /* Change the value of a global variable. */
}

/* This is the main function */
int main()
{
  /* Local variables. */
  int m;
  int * p; /* Declare p as pointer, so that p can hold an address. */
  char c[ 4 ] = "Hej"; 

  /* Do some calculation. */
  gv = 4;
  m = gv + in;

  /* Check the addresses and values of some variables and stuff */
  saveword( "AM1: gv", &gv );
  saveword( "AM2: in", &in );
  saveword( "AM3: fun", &fun );
  saveword( "AM4: main", &main );

  p = &m;

  /* Check p and m */
  saveword( "AM5: p", &p );
  saveword( "AM6: m", &m );

  /* Change *p */

  *p = *p + 1;

  /* Check p and m */
  saveword( "AM7: p", &p );
  saveword( "AM8: m", &m );

  p = (int*)c;   /* Casting a char pointer to a integer pointer */

  saveword( "AM9: p", &p );

  savebyte( "AM10: c[0]", &c[0] );
  savebyte( "AM11: c[1]", &c[1] );
  savebyte( "AM12: c[2]", &c[2] );
  savebyte( "AM13: c[3]", &c[3] );

  *p = 0x1234abcd; /* It starts to get interesting... */

  savebyte( "AM14: c[0]", &c[0] );
  savebyte( "AM15: c[1]", &c[1] );
  savebyte( "AM16: c[2]", &c[2] );
  savebyte( "AM17: c[3]", &c[3] );

  fun(m);

  /* Re-check the addresses and values of m and gv */
  saveword( "AM18: m", &m );
  saveword( "AM19: gv", &gv );

  showinfo();
}


/*

  QUESTION 1
  *********************************************************
  Which addresses are variables in and gv located at? 
  Which memory sections according to the PIC32 memory map? Why?

  in - A0000008
  gv - A000000C

  These are located in the Virtual Section, KSEG1 section, in RAM. 
  It's a place in memory that is not reserved and we can save there.







  QUESTION 2
  *********************************************************
  Which addresses have fun and main? Which sections are they located in? 
  What kind of memory are they stored in? 
  What is the meaning of the data that these symbols points to?

  main is located at 9D0011D8 (Program Flash)
  fun is located at  9D001180 (Program Flash)

  Both are located in the program flash section because they are methods.
  Program flash is used to store programs and tables of data.

  The code of a function is stored in flash.

  The data is the beginning 4 bytes of the main and fun methods.








  QUESTION 3
  *********************************************************
  Variables p and m are not global variables. 
  Where are they allocated? 
  Which memory section is used for these variables? 
  Why are the address numbers for p and m much larger than for in and gv?

  m is stored at A0003FE8
  p is stored at A0003FEC

  RESERVED SECTION
  because m and p are local variables and are therefore stored in the stack. 

  The numbers are bigger because the reserved section is allocated at higher adresses in the virtual memory.








  QUESTION 4
  *********************************************************
  At print statement AM5, what is the address of pointer p, 
  what is the value of pointer p, and what value is pointer p pointing to?

  Adress of pointer p is A0003FEC. 
  *p is a pointer and when we write &p we take the adress where the pointer ITSELF is stored

  The adress the pointer is pointing to is A0003FE8. which is &m (adress to m)

  The value is 7 because m (in+gv=3+4) is 7





  QUESTION 5
  *********************************************************
  At print statement AM7, what is the address of pointer p, 
  what is the value of pointer p, and what value is pointer p pointing to?

  
  Adress of pointer p is A0003FEC. 
  *p is a pointer and when we write &p we take the adress where the pointer ITSELF is stored

  The adress the pointer is pointing to is A0003FE8. which is &m (adress to m)

  The value is 8 because we do *p=*p+1 which increase THE VALUE p is pointing to by 1





  QUESTION 6
  *********************************************************
  Pointer c is a character pointer that points to a sequence of bytes. 
  What is the size of the c pointer itself?

  A pointer is a memory adress of 32 bits. 
  It holds 8 hex values. 
  Each hex is 4 bits. 4*8=32






  QUESTION 7
  *********************************************************
  Explain how a C string is laid out in memory. 
  Why does the char string that c points to have to be 4 bytes?

  The strings are 0-terminated which means they always end with \0.
  Therefore we need 4 bytes when the string only has 3 characters.








  QUESTION 8
  *********************************************************
  Consider AM14 to AM17. 
  Is the PIC32 processor using big-endian or little-endian? Why?

  PIC32 is littler endian.
  We change the value of c to 0x1234abcd by setting the value of p to it. 
  p is pointing to the same value as c.
  *p = 0x1234abcd; 

  When we look at the output 
  c[0] is cd
  c[1] is ab 
  c[2] is 34
  c[3] is 12

  The least significat value (cd) comes first and therefore it's little endian. 









  QUESTION 9
  *********************************************************
  Consider AM18, AM19, and AF1. 
  Explain why gv ends up with the incremented value, but m does not.

  In the fun function we increment only the local parameter.
  Then we assign that incremented value to gv.

  

*/


