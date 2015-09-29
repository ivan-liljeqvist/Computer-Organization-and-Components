
#include <stdint.h>
#include <pic32mx.h>
#include "mipslab.h"


/*
    Returns the status of the toggle-switches on the board.
*/

int getsw(void){

    /*
        1) mask away all the bits except 8-11 where the switches are
        2) shift them all the way to the right
    */
    return (PORTD & 0xF00)>>8; 


}

/*
    Returns the current status of the push-buttons BTN2, BTN3, and BTN4 
*/

int getbtns(void){
    /*
        1) mask away all the bits except 7-5 where the switches are
        2) shift them all the way to the right
    */
    return (PORTD & 0xE0)>>5; 
}



