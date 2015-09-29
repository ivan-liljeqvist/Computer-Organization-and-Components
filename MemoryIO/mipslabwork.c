/* mipslabwork.c

   This file written 2015 by F Lundevall

   This file should be changed by YOU! So add something here:

   This file modified 2015-12-24 by Ture Teknolog 

   Latest update 2015-08-28 by F Lundevall

   For copyright and licensing, see file COPYING */

#include <stdint.h>   /* Declarations of uint_32 and the like */
#include <pic32mx.h>  /* Declarations of system-specific addresses etc */
#include "mipslab.h"  /* Declatations for these labs */

int mytime = 0x5957;
volatile int* porte=0xbf886110;

char textstring[] = "text, more text, and even more text!";

/* Interrupt Service Routine */
void user_isr( void )
{
  return;
}

/* Lab-specific initialization goes here */
void labinit( void )
{
  volatile int *triseclr = (volatile int*)0xbf886104; //checked the value of TRISECLR in header 
  //set 0-7 bits to ones in TRISECLR so that those bits in TRISE will become 0 (output)
  //other bits wont be changed when using TRISECLR
  *triseclr = 0xFF; 


  TRISDCLR = 0xFE0; //bits 11-5 set to 1 so that they will be 0 in TRISD (output)


  return;
}

/* This function is called repetitively from the main program */
void labwork( void )
{
  delay( 1000 );
  time2string( textstring, mytime );
  display_string( 3, textstring );
  display_update();
  tick( &mytime );
  display_image(96, icon);

  *porte=*porte+1; //add one to PORTE which will change the LEDs so they shine in binary

}
