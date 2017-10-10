//Can I leave out the config. statements if they have already been made in the higher program
#include <pic.h>
#include <htc.h>

#define _XTAL_FREQ 500000

void loop(){
	
	 ANSELA = 0x00;
	 __delay_ms(200);

	 #define OUTPUT 0
	 #define INPUT 1

	 TRISA = OUTPUT;

	while(1){
		
		
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
}


