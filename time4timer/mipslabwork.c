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

char textstring[] = "text, more text, and even more text!";

int timeout=0;

/* Interrupt Service Routine */
void user_isr( void )
{
  return;
}

/* Lab-specific initialization goes here */
void labinit( void )
{

  //stop the clock until the init is finished
  T2CON = 0x00; //set the first bit to 0 to stop

  /*
    bit6-4 = 11 because we want 1:256 scaling on the clock
  */

  T2CONSET = 0x070; //0111 0000 we set the prescaling. 
  //T2CONSET will not alter all positions with 0

  TMR2 = 0x00; //clear the timer
  PR2 = 0x7A12; //31250 = 80MGz/256/10. So the timer will reset 10 times each second

  T2CONSET = 0x8000; //set first bit to 1. 8 = 1000


  return;
}

/* This function is called repetitively from the main program */
void labwork( void )
{

  //IN TABLE 4-4 on page 53 we found that T2IF is bit 8 in IFS0  

  if(IFS(0) & 0x100){
    time2string( textstring, mytime );
    display_string( 3, textstring );
    display_update();
    tick( &mytime );
    display_image(96, icon);

    IFSCLR(0)=0x100; //clear only T2IF bit (bit 8)
  }
  
}

/**
  
*/
