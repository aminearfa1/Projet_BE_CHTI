#include "gassp72.h"
#define SYSTICK_PER 360000
//la fr�quence (0 pour F1,....) qui correspond � la DFT calcul�e
extern int indice_max;
//buffer pour stcoker la fen�tre
volatile short Buffer[64];
// initialisation du Tab_Compteurs � 0
// contient l'indice correspondant aux 6 fr�quences (0 pour F1, .....)
volatile int Tab_Compteurs[6]={0,0,0,0,0,0};
//contient les scores correspondant aux 6 fr�quences
int tab_scores[6]={0,0,0,0,0,0};
//fonction callback du timer d'interruption
void sys_callback();

int main(){
	int i = 0;
	// activation de la PLL qui multiplie la fr�quence du quartz par 9
	CLOCK_Configure();
	// PA2 (ADC voie 2) = entr�e analog
	GPIO_Configure(GPIOA, 2, INPUT, ANALOG);
	// PB1 = sortie pour profilage � l'oscillo
	GPIO_Configure(GPIOB, 1, OUTPUT, OUTPUT_PPULL);
	// PB14 = sortie pour LED
	GPIO_Configure(GPIOB, 14, OUTPUT, OUTPUT_PPULL);

	// activation ADC, sampling time 1us
	Init_TimingADC_ActiveADC_ff( ADC1, 72 );
	Single_Channel_ADC( ADC1, 2 );
	// D�clenchement ADC par timer2, periode (72MHz/320kHz)ticks
	Init_Conversion_On_Trig_Timer_ff( ADC1, TIM2_CC2, 225 );
	// Config DMA pour utilisation du buffer dma_buf (a cr��r)
	Init_ADC1_DMA1( 0, Buffer );

	// Config Timer, p�riode exprim�e en p�riodes horloge CPU (72 MHz)
	Systick_Period_ff( SYSTICK_PER );
	// enregistrement de la fonction de traitement de l'interruption timer
	// ici le 3 est la priorit�, sys_callback est l'adresse de cette fonction, a cr��r en C
	Systick_Prio_IT( 3, sys_callback );
	SysTick_On;
	SysTick_Enable_IT;
	while (1){
		//on ne prend en compte que la DFT sur 3 fen�tres cons�cutives
		if (Tab_Compteurs[indice_max] == 3){
			//incr�menter le score
			tab_scores[indice_max]++;
			//la DFT est prise en compte donc on peut r�initialiser tab_compteurs
			Tab_Compteurs[indice_max]=0;
			//le temps que la led s'allume 
			for(i=0;i<100000;i++){
				//Allumer la LED
				GPIO_Set(GPIOB,14);
			};
			
		}
		else{
			//eteindre la LED
			GPIO_Clear(GPIOB,14);
		}
	};
		

return -1;
}
