




int getsw(void);
int getbtns(void);


/*

  Q:
  If you press BTN3 and BTN2 at the same time, what happens? Why?


  A:
  We have If-Else, BTN2 will be executed and BTN3 ignored.
  If the switches are set high, the minutes will increase because the seconds become >60

  **********************************************************************

  Q:
  If you press BTN3 quickly, does the time update reliably? Why, or why not?

  A:
  No, because we delay with 1 seconds each iteration, and therefore read only once each second.


  **********************************************************************

  Q:
  Three device-registers for input/output control are TRISE, TRISESET, and 
  TRISECLR. Their functions are related. How? What are the differences? 
  Did you use one or more of these device-registers in your code? 
  Why, or why not?

  A:

  TRISE - specify exactly which bits are (0) output and (1) input
  TRISECLR - sets TRISE to 0 where TRISECLR is 1 and doesnt touch anything else
  TRISESET - set TRISE to 1 where TRISECLR is 1 and doesnt touch anything else

  we used only SET and CLR to only change the bits we are interested in

  **********************************************************************

  Q: 

  In the generated assembly code, 
  in which MIPS register will the return values from functions getbtns and getsw 
  be placed in. You should be able to answer this question without debugging the 
  generated assembly code.

  A:

  v0

  *********************************************************************
  Q:

  How can you find this information in the PIC32 and ChipKIT manuals? 
  Be prepared to explain the procedure for how to find this information in the manuals.

  A:

  Uno basic shield manual.
  P. 3 = bits specifically
  P. 8 = Pinout Table
*/