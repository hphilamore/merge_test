//PROGRAM TO STORE AN A/D VALUE TAKEN AT PIN RA0

#include <pic.h>
#include <htc.h>

#define _XTAL_FREQ 500000

//Create A/D storge values for high and low registers and clear them
int addvalueH = 0;
int addvalueL = 0;
int addvalueTotalH = 0;
int	addvalueTotalL = 0;
int addvalueTotalVREF = 0;
int addvalueTotalVdd = 0;
int addvalueTotal = 0;
		

main(){

// 1. Configure Port:
// • Disable pin output driver for (Refer to the TRIS register)
// config pin 0 input and pins 1-5 output

TRISA = 0b00000001;

// • Configure pin as analog (Refer to the ANSEL register)
// config pin 0 as analog and 1-5 digital

ANSELA = 0b0000001;

// 2. Configure the ADC module to read internal reference VREF+:
// • Select ADC conversion clock (A/D convert works during sleep only when intosc Frc is enabled)
// • Configure posistive voltage reference voltage reference (VREF+ is connected to Fixed Voltage Reference (FVR) module = 1V)

ADCON1 = 0b0111011;

// • Select ADC input channel (VREF+)
// • Turn on ADC module

ADCON0= 0b01111101;
		
// 3. Wait the required acquisition time(2).
__delay_ms(1);
		
// 4. Start conversion by setting the GO/DONE bit.

	
ADGO = 1;
//GODONE = 1;
//ADCON0 = 10;
		
// 5. Wait for ADC conversion to complete by one of
// the following:
// • Polling the GO/DONE bit
// • Waiting for the ADC interrupt (interrupts
// enabled)

while (ADGO==1);		
//__delay_ms(2000);
//while (GODONE==1)

		
		
// 6. Read ADC Result from VREF+.
//Store ADRESH result in variable: addvalueH
//Store ADRESL result in variable: addvalueL
//Store concatonated value in variable: addvalueTotalVREF+
		
addvalueH = ADRESH;
addvalueL = ADRESL;

addvalueTotalH = addvalueH << 2;
addvalueTotalL = addvalueL >> 6;
		
		//addvalueTotalH = addvalueH * 4;
		//addvalueTotalL = addvalueL / 64;
		
addvalueTotalVREF = addvalueH + addvalueL;

//7. Start while loop to sample Vdd (RA0) and compare with VREF+

while (1)
	{

		// 8. Re-configure the ADC module to read RA0:
		// • Select ADC input channel (RA0)
		// • Turn on ADC module
		
		ADCON0= 0b00000001;
		
		// IS STEP 3 NEEDED??
		// 3. Configure ADC interrupt (optional):
		// • Clear ADC interrupt flag
		// • Enable ADC interrupt
		// • Enable peripheral interrupt
		// • Enable global interrupt(1)
		
		
		// 9. Wait the required acquisition time(2).
		__delay_ms(1);
		
		// 10. Start conversion by setting the GO/DONE bit.

	
		
		ADGO = 1;
		//GODONE = 1;
		//ADCON0 = 10;
		
		// 11. Wait for ADC conversion to complete by one of
		// the following:
		// • Polling the GO/DONE bit
		// • Waiting for the ADC interrupt (interrupts
		// enabled)
		
		while (ADGO==1);
		//__delay_ms(2000);
		//while (GODONE==1)
		
		
		
		// 12. Read ADC Result from RA0.
		//Store ADRESH result in variable: addvalueH
		//Store ADRESL result in variable: addvalueL
		//Store concatonated  result in variable: addvalueVdd

		addvalueH = ADRESH;
		addvalueL = ADRESL;

		addvalueTotalH = addvalueH << 2;
		addvalueTotalL = addvalueL >> 6;
		
		//addvalueTotalH = addvalueH * 4;
		//addvalueTotalL = addvalueL / 64;
		
		addvalueTotalVdd = addvalueH + addvalueL;

		

		//13. Divide VREF+ by RA0 to find VREF+/Vdd result.
		addvalueTotal =  addvalueTotalVREF / addvalueTotalVdd;


		// Start a while loop to run the switch program when 1.8V > addvalueTotal > 3V
		while (1.8 > addvalueTotal > 3)
		{

		 //RA0 = 0;
		 //RA1 = 0;
		 RA4 = 0;
		 RA5 = 0;
		 __delay_ms(2000);

		 //RA0 = 1;
		 //RA1 = 0;
		 RA4 = 1;
		 RA5 = 0;
		 __delay_ms(2000);

		 //RA0 = 0;
		 //RA1 = 0;
		 RA4 = 0;
		 RA5 = 0;
		 __delay_ms(2000);

		 //RA0 = 0;
		 //RA1 = 1;
		 RA4 = 0;
		 RA5 = 1;
		 __delay_ms(2000);
	 	}

				

	}
}

//HOW TO USE THE RESULT OF THE A/D CONVERT TO WAKE UP AND START PROGRAM AT VDD/RA0 = 3V (voltage increasing) AND STOP THE PROGRAM AND GO TO SLEEP AT VDD/RA0 = 1.8V (voltage decreasing)

// 8. Clear the ADC interrupt flag (required if interrupt
// is enabled). 
	
	
	
		


