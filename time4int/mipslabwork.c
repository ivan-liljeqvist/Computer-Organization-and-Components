/* mipslabwork.c

   This file written 2015 by F Lundevall

   This file should be changed by YOU! So add something here:

   This file modified 2015-12-24 by Ture Teknolog 

   Latest update 2015-08-28 by F Lundevall

   For copyright and licensing, see file COPYING */

#include <stdint.h>   /* Declarations of uint_32 and the like */
#include <pic32mx.h>  /* Declarations of system-specific addresses etc */
#include "mipslab.h"  /* Declatations for these labs */

int prime = 1234567;

int mytime = 0x5957;


volatile int* porte=0xbf886110;

int timeoutcount=0;

char textstring[] = "text, more text, and even more text!";

/* Interrupt Service Routine */
void user_isr( void ) {

  IFS(0) = 0;

  timeoutcount++;

  if(timeoutcount==10){
    time2string( textstring, mytime );
    display_string( 3, textstring );
    display_update();
    tick( &mytime );

    timeoutcount=0;    
  }
  


}

/* Lab-specific initialization goes here */
void labinit( void )
{

  /** ASSIGNMENT 1 */
  volatile int *triseclr = (volatile int*)0xbf886104; //checked the value of TRISECLR in header 
  //set 0-7 bits to ones in TRISECLR so that those bits in TRISE will become 0 (output)
  //other bits wont be changed when using TRISECLR
  *triseclr = 0xFF; 


  TRISDSET = 0xFE0; //bits 11-5 set to 1 so that they will be 0 in TRISD (output)

   /** ASSIGNMENT 2 */

  //stop the clock until the init is finished
  T2CON = 0x0; //set the first bit to 0 to stop

  /*
    bit6-4 = 11 because we want 1:256 scaling on the clock
  */

  T2CONSET = 0x070; //0111 0000 we set the prescaling. 
  //T2CONSET will not alter all positions with 0

  TMR2 = 0x0; //clear the timer
  PR2 = 0x7A12; //31250 = 80MHz/256/10. So the timer will reset 10 times each second

  T2CONSET = 0x8000; //set first bit to 1. 8 = 1000 start the cloc

  IPCSET(2)=4; //enable timer2 iterrupts. 4 = 100 and bits 4,3,2 in IPS have
  //the value for timer2 priority. bits 4,3,2 will become 001 

  IECSET(0)=256; // 1 0000 0000 We want to set bit 8 to enable iterrupts from timer2. table 4-4

  enable_interrupt(); //our own assembler subroutine that runs ei and enables interrupts

  return;
}

/* This function is called repetitively from the main program */
void labwork( void ) {
  prime = nextprime( prime );
  display_string( 0, itoaconv( prime ) );
  display_update();
}

/**

• How is the time-out event-flag checked?
• When the time-out event-flag is a "1", how does your code reset it to "0"?
• What would happen if the time-out event-flag was not reset to "0" by your code? Why?
• For this assignment, please make a new estimate of how many times per second your code checks the time-out event-flag: 1, 10, 100, 1000, 10 000, 100 000, a million, 10 million, 100 million times? How did you calculate your answer?
• From which part of the code is the function user_isr called? Why is it called from there?
• Why are registers saved before the call to user_isr? Why are only some registers saved?
• Is the function user_isr called from the labwork function? Why, or why not?
• Which part (or parts) of your code is (are) required to enable interrupts from the timer?
• If the time-out event-flag changes to a "1" while the function display_string is running, could the display show some kind of incorrect pattern – perhaps wrong numbers or so? If so,
for how long would the pattern be displayed? Make a reasonable estimate. These two questions are difficult, so it's okay not to have a perfect answer.


*/
