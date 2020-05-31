;typedef struct {
;int position;		// index courant dans le tableau d'echantillons
;int taille;		// nombre d'echantillons de l'enregistrement
;short int * son;	// adresse de base du tableau d'echantillons en ROM
;int resolution;	// pleine echelle du modulateur PWM
;int periode_ticks;	// periode d'ech. audio en periodes d'horloge CPU
;} type_etat;

;/*
E_POS	equ	0
E_TAI	equ	4
E_SON	equ	8
E_RES	equ	12
E_PER	equ	16
	end
;*/
