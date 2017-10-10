//Edit for github purpose ***
//Ed it for github
//PROGRAM TO COMPARE AN A/D VALUE FOR BAT_OK, TAKEN AT PIN RA0, WITH VDD TO SEE IF HIGH OR LOW AND PUT THE PIC TO SLEEP ACCORDINGLY
//Could a digital input be used instead of A/D input?

#include <pic.h>
#include <htc.h>

#define _XTAL_FREQ 500000

//Create A/D storge values for high and low registers and clear them
int addvalueH = 0;
int addvalueL = 0;

main(){

// 1. Configure Port:
// • Disable pin output driver for (Refer to the TRIS register)
// config pin 0 input and pins 1-5 output

TRISA = 0b00000001;

// • Configure pin as analog (Refer to the ANSEL register)
// config pin 0 as analog and 1-5 digital

ANSELA = 0b0000001;

// 2. Configure the ADC module:
// • Select ADC conversion clock (A/D convert works during sleep only when intosc Frc is enabled)
// • Configure voltage reference (VREF+ is connected to AVDD)

ADCON1 = 0b0111000;

// • Select ADC input channel
// • Turn on ADC module

ADCON0= 0b00000001;

// IS STEP 3 NEEDED??
// 3. Configure ADC interrupt (optional):
// • Clear ADC interrupt flag
// • Enable ADC interrupt
// • Enable peripheral interrupt
// • Enable global interrupt(1)


// 4. Wait the required acquisition time(2).


// 5. Start conversion by setting the GO/DONE bit.

while (1)
{
ADCON0 = 10;
//GODONE = 1;

// 6. Wait for ADC conversion to complete by one of
// the following:
// • Polling the GO/DONE bit
// • Waiting for the ADC interrupt (interrupts
// enabled)

__delay_ms(2000);
//while (GODONE==1)



// 7. Read ADC Result.
//Store ADRESH result in variable: addvalueH
//Store ADRESL result in variable: addvalueL

addvalueH = ADRESH;
addvalueL = ADRESL;

}
}

//HOW TO USE THE RESULT OF THE A/D CONVERT TO WAKE UP AND START PROGRAM AT VDD/RA0 = 3V (voltage increasing) AND STOP THE PROGRAM AND GO TO SLEEP AT VDD/RA0 = 1.8V (voltage decreasing)

// 8. Clear the ADC interrupt flag (required if interrupt
// is enabled). 
	
	
	
		// //RA0 = 0;
		// //RA1 = 0;
		// RA4 = 0;
		// RA5 = 0;
		// __delay_ms(2000);

		// //RA0 = 1;
		// //RA1 = 0;
		// RA4 = 1;
		// RA5 = 0;
		// __delay_ms(2000);

		// //RA0 = 0;
		// //RA1 = 0;
		// RA4 = 0;
		// RA5 = 0;
		// __delay_ms(2000);

		// //RA0 = 0;
		// //RA1 = 1;
		// RA4 = 0;
		// RA5 = 1;
		// __delay_ms(2000);
	// }
// }


;

// 2. Configure the ADC module:
// • Select ADC conversion clock (A/D convert works during sleep only when intosc Frc is enabled)
// • Configure voltage reference (no voltage ref.)

ADCON1 = 0b0111000;

// • Select ADC input channel
// • Turn on ADC module

ADCON0= 0b00000001;

// IS STEP 3 NEEDED??
// 3. Configure ADC interrupt (optional):
// • Clear ADC interrupt flag
// • Enable ADC interrupt
// • Enable peripheral interrupt
// • Enable global interrupt(1)


// 4. Wait the required acquisition time(2).


// 5. Start conversion by setting the GO/DONE bit.

while (1)
{
ADCON0 = 10;
//GODONE = 1;

// 6. Wait for ADC conversion to complete by one of
// the following:
// • Polling the GO/DONE bit
// • Waiting for the ADC interrupt (interrupts
// enabled)

__delay_ms(2000);
//while (GODONE==1)



// 7. Read ADC Result.
//Store ADRESH result in variable: addvalueH
//Store ADRESL result in variable: addvalueL

addvalueH = ADRESH;
addvalueL = ADRESL;

}
}

//HOW TO USE THE RESULT OF THE A/D CONVERT TO WAKE UP AND START PROGRAM AT VDD/RA0 = 3V (voltage increasing) AND STOP THE PROGRAM AND GO TO SLEEP AT VDD/RA0 = 1.8V (voltage decreasing)

// 8. Clear the ADC interrupt flag (required if interrupt
// is enabled). 
	
	
	
		// //RA0 = 0;
		// //RA1 = 0;
		// RA4 = 0;
		// RA5 = 0;
		// __delay_ms(2000);

		// //RA0 = 1;
		// //RA1 = 0;
		// RA4 = 1;
		// RA5 = 0;
		// __delay_ms(2000);

		// //RA0 = 0;
		// //RA1 = 0;
		// RA4 = 0;
		// RA5 = 0;
		// __delay_ms(2000);

		// //RA0 = 0;
		// //RA1 = 1;
		// RA4 = 0;
		// RA5 = 1;
		// __delay_ms(2000);
	// }
// }


