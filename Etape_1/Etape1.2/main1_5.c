#include "gassp72.h"
#include "etat.h"
#define Periode_en_Tck PeriodeSonMicroSec*72 //4536 // T/T0 ici 63u
#define Periode_PWM_en_Tck 720 // 10u // plus ou moins 6.3µ 

extern short Son;
extern int LongueurSon;
extern int PeriodeSonMicroSec;
void timer_callback (void);

type_etat etat;


int main(void)
{
// initialisation de taille et son de variable etat
etat.taille = LongueurSon;
etat.son = &Son;
etat.periode_ticks = PeriodeSonMicroSec;
// activation de la PLL qui multiplie la fréquence du quartz par 9
CLOCK_Configure();
/*// config port PB1 pour être utilisé en sortie
GPIO_Configure(GPIOB, 1, OUTPUT, OUTPUT_PPULL);
*/
	
// config port PB0 pour être utilisé par TIM3-CH3
GPIO_Configure(GPIOB, 0, OUTPUT, ALT_PPULL);
// config TIM3-CH3 en mode PWM
etat.resolution = PWM_Init_ff( TIM3, 3, Periode_PWM_en_Tck );	
	
	
// initialisation du timer 4
// Periode_en_Tck doit fournir la durée entre interruptions,
// exprimée en périodes Tck de l'horloge principale du STM32 (72 MHz)
Timer_1234_Init_ff( TIM4, Periode_en_Tck );
// enregistrement de la fonction de traitement de l'interruption timer
// ici le 2 est la priorité, timer_callback est l'adresse de cette fonction, a créér en asm,
// cette fonction doit être conforme à l'AAPCS
Active_IT_Debordement_Timer( TIM4, 2, timer_callback );
// lancement du timer
Run_Timer( TIM4 );
Run_Timer( TIM3 );
while (1) {

}
}
