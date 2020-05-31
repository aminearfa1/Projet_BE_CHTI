#include "gassp72.h"
#define INTERVALLE 360000 // Une periode d'horloge vaut 1/(72.10^6) s, donc pour avoir une dur�e de 1/100 (100Hz) on r�soud 
// INTERVALLE* 1/(72.10^6) = 1/100 => INTERVALLE = 720000
void timer_callback();
void GPIO_B_init();
volatile int signal ; // Signal est une variable que l'on utilisera pour connaitre  en temps r�el la valeur du signal carr� (0 ou 1)
int main(){
	// On initialise le signal � 0
	signal=0;
	// activation de la PLL qui multiplie la fr�quence du quartz par 9
	CLOCK_Configure();
	// initalisation GPIO-B (on garde le driver de l'exercice pr�d�dent)
	GPIO_B_init();
	// initialisation du timer 4
	// INTERVALLE doit fournir la dur�e entre interruptions,
	// exprim�e en p�riodes de l'horloge CPU (72 MHz)
	Timer_1234_Init_ff( TIM4, INTERVALLE );
	// enregistrement de la fonction de traitement de l'interruption timer
	// ici le 2 est la priorit�, timer_callback est l'adresse de cette fonction, a cr��r en asm,
	// cette fonction doit �tre conforme � l'AAPCS
	Active_IT_Debordement_Timer( TIM4, 2, timer_callback );
	// lancement du timer
	Run_Timer( TIM4 );
	// boucle infinie
	while(1);
}