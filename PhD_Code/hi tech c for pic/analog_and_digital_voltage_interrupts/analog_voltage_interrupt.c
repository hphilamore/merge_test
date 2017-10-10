//PROGRAM TO COMPARE AN A/D VALUE FOR BAT_OK, TAKEN AT PIN RA0, WITH VDD TO SEE IF HIGH OR LOW AND PUT THE PIC TO SLEEP ACCORDINGLY
//Could a digital input be used instead of A/D input?

#include <pic.h>
#include <htc.h>

#define _XTAL_FREQ 500000

//Declare constant value for [FVR (mV) * 1024]
#define Cfvr 1048576;

//Create A/D storge values for high and low registers and clear them
int addvalueH = 0;
int addvalueL = 0;
int addvalueTotalH = 0;
int addvalueTotalL = 0;
int addvalueTotal = 0;

// DECLARE FUNCTION PROTOTYPE?
void loop();   

//Create value for Vdd calculated
int VddVal = 0;

main(){

// 1. Configure Port:
// • Disable pin output driver for (Refer to the TRIS register)
// config pins 0-5 output

TRISA = 0b00000000;

// • Configure pin as analog (Refer to the ANSEL register)
// config pins 0-5 digital

ANSELA = 0b0000000;

// 2. Configure the ADC module:
// • Select ADC conversion clock (A/D convert works during sleep only when intosc Frc is enabled)
// • Configure voltage reference (VREF+ is connected to AVDD)

ADCON1 = 0b0111000;

// • Select ADC input channel as FVR (Fixed Voltage Reference) Buffer 1 Output
// • Turn on ADC module

ADCON0= 0b01111101;

// IS STEP 3 NEEDED??
// 3. Configure ADC interrupt (optional):
// • Clear ADC interrupt flag
// • Enable ADC interrupt
// • Enable peripheral interrupt
// • Enable global interrupt(1)


// 4. Wait the required acquisition time(2).
__delay_ms(1);


// 5. Start conversion by setting the GO/DONE bit.

while (1)
		{
		ADGO = 1;

// 6. Wait for ADC conversion to complete by one of
// the following:
// • Polling the GO/DONE bit
// • Waiting for the ADC interrupt (interrupts
// enabled)

		while (ADGO==1);



// 7. Read ADC Result.
//Store ADRESH result in variable: addvalueH
//Store ADRESL result in variable: addvalueL

		addvalueH = ADRESH;
		addvalueL = ADRESL;
		
// 8. Convert 10 bit ADC result, from 8 bit H register and 8 bit L register, split over two 16 bit integers, 
//into one 16 bit integer. 
		
		addvalueTotalH = addvalueH << 2;
		addvalueTotalL = addvalueL >> 6;
		
		//addvalueTotalH = addvalueH * 4;
		//addvalueTotalL = addvalueL / 64;
		
		addvalueTotal = addvalueTotalH + addvalueTotalL;
		
// 9. Find Vdd (mV) using measured binary value for FVR and known constant: FVR 1024(mV)* 1024 
		
		VddVal = addvalueTotal*Cfvr

// 10. Run program from when VddVal=3V down to when VddVal=1.8V 
		
			if (VddVal > 3000);
							{
							while (VddVal>1800)
										{
										loop();			// CALL FUNCTION

										}
							}


			
		
		}
}

void loop()		// DEFINE CUSTOM FUNCTION		
						
					
							{
		
		
							RA4 = 0;
							RA5 = 0;
							__delay_ms(2000);
					
							RA4 = 1;
							RA5 = 0;
							__delay_ms(2000);
					
							
							RA4 = 0;
							RA5 = 0;
							__delay_ms(2000);
					
							
							RA4 = 0;
							RA5 = 1;
							__delay_ms(2000);
						
							}

//HOW TO USE THE RESULT OF THE A/D CONVERT TO Generate an interrupt that WAKEs UP AND START PROGRAM AT VDD/RA0 = 3V (
//voltage increasing) AND STOP THE PROGRAM AND GO TO SLEEP AT VDD/RA0 = 1.8V (voltage decreasing)

