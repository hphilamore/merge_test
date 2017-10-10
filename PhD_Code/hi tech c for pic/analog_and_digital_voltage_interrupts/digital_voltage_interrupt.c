
#include <pic.h>
#include <htc.h>

#define _XTAL_FREQ 500000

//Give pin 2 the nickname BAT_OK
//#define BAT_OK RA2;

// DECLARE FUNCTION PROTOTYPE
void loop();   

main(){

//PORTA bank cleared before TRISA set 'to avoid glitch pulses during initialisation'

PORTA = 0;

// 1. Configure Port:
// Disable pin output driver for (Refer to the TRIS register)
// config pin 2 and 3 input and pins 1,4,5 output

TRISA = 0b00001100;

// Configure pin as digital (Refer to the ANSEL register)
// config pins 0-5 digital

ANSELA = 0b0000000;

	while (1)
			{

		
			while (RA2 == 1)

					{

	// HOW TO INCLUDE A FUNCTION (LOOP) THAT SWITCHES IPMC?
	// HOW TO GO ABOUT PLACING THAT FUNCTION IN A SEPARATE .C FILE?
	 
					
					loop();			// CALL FUNCTION
					
									
						
									
					
					 }					
			
			}
}


//Define loop function
void loop()
{
					RA4 = 0;
					RA5 = 0;
					__delay_ms(100);
			
					RA4 = 1;
					RA5 = 0;
					__delay_ms(100);
			
					
					RA4 = 0;
					RA5 = 0;
					__delay_ms(100);
			
					
					RA4 = 0;
					RA5 = 1;
					__delay_ms(100);
				
							
						

}

//HOW TO USE THE RESULT OF THE A/D CONVERT TO Generate an interrupt that WAKEs UP AND START PROGRAM AT VDD/RA0 = 3V (
//voltage increasing) AND STOP THE PROGRAM AND GO TO SLEEP AT VDD/RA0 = 1.8V (voltage decreasing)

