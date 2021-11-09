// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int main()
{
	int i = 0;
	volatile unsigned int *LED_PIO = (unsigned int*)0x40; //make a pointer to access the PIO block
	volatile unsigned int *SW_IN = (unsigned int*)0x60; // a pointer to access the switch
	volatile unsigned int *KEY = (unsigned int*) 0x50;// RESET

	int accumulator = 0;
	
	while(true){
		if(*KEY_2 == 0x10)
			accumulator = 0;
		else if(*KEY_3 == 0x01)
		{
			accumulator += *SW_IN;
			if(accumulator > 255)
				accumulator -= 256;
		}
		else
			accumulator |= 0xFF; //keep the value
	}	
	return 1;

}
