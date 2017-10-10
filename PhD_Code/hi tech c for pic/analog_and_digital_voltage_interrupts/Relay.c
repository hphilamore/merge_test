#include <pic.h>
#include <htc.h>

#define _XTAL_FREQ 500000

main(){
	
	ANSELA = 0x00;
	__delay_ms(200);

	#define OUTPUT 0
	#define INPUT 1

	TRISA = OUTPUT;

	while(1){
		
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


