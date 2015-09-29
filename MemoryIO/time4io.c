
#include <stdint.h>
#include <pic32mx.h>
#include "mipslab.h"


/*
    Returns the status of the toggle-switches on the board.
*/

int getsw(){

    /*
        1) mask away all the bits except 8-11 where the switches are
        2) shift them all the way to the right
    */
    return (PORTD & 0xF00)>>8; 


}