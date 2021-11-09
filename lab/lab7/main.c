// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int main()
{
	int i = 0;
	volatile unsigned int *LED_PIO = (unsigned int*)0x40; //make a pointer to access the PIO block
	volatile unsigned int *SW_IN = (unsigned int*)0x60; // a pointer to access the switch
	volatile unsigned int *KEY_2 = (unsigned int*) // RESET
	volatile unsigned int *KEY_3 = (unsigned int*)  // accumulate
	int accumulator = 0;
	while(true){
		if(*KEY_2 == 0)
			accumulator = 0;
		else if(*KEY_3 == 0)
			accumulator += *SW_IN;
		else
			accumulator |= 0xFF; //keep the value
	}	
	return 1;

}
