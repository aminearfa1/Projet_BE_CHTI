#include "gassp72.h"
#define M2TIR 0x7c1
//0x7c1

extern int  Buffer;
extern int  Tab_Compteurs;
int M2(int,int*);
volatile int indice_max;
int l=0;
int k=0;
	int j=0;
	int s=0;

void sys_callback(){

	
	indice_max = 0;
	//pour profilage à l'oscilloscope
	GPIO_Set(GPIOB,1);
	// Démarrage DMA pour 64 points
	Start_DMA1(64);
	Wait_On_End_Of_DMA1();
	Stop_DMA1;

	//calcul de la DFT pour chacune des 6 freq

	// pour F1 à F4 (85 à 100 kHz par pas de 5)
	
	for (k=17;k<=20;k++){
		j=k;
		s=M2(k,&Buffer);
		k=j;
		if (s >= M2TIR){
		
		//on incrémente dans le tableau de compteurs à la position souhaitée 
		// par exemple : F1 case 0, F2 case 1 etc.
			(&Tab_Compteurs)[k-17]++;
			if((&Tab_Compteurs)[k-17]>=(&Tab_Compteurs)[indice_max]){
				indice_max = k-17;
			}
		}
		else{
			(&Tab_Compteurs)[k-17]=0;
		}
		l++;
	}

	// pour F5 et F6 (115 et 120 kHz)
	for (k=23;k<=24;k++){
		j=k;
		s=M2(k,&Buffer);
		k=j;
		if (s>= M2TIR){
			(&Tab_Compteurs)[k-19]++;
			if((&Tab_Compteurs)[k-19]>=(&Tab_Compteurs)[indice_max]){
				indice_max = k-19;
			}
		}
		else{
			(&Tab_Compteurs)[k-19]=0;
		}
		l++;
	}

	
	GPIO_Clear(GPIOB, 1);
}