	thumb
	area	reset, data, readonly

	;export __Vectors
	export Somme
	area	reset, data, readwrite
N	EQU	64

Blabla
	dcd	0x20004000	; stack en fin de la zone de 20k de RAM
	; point d'entree de notre programme
;
	area	moncode, code, readonly

;fonction Somme  calcule la partie réelle ou imaginaire de la DFT de n'importe quel signal pour une fréquence donnée.
;param r0: indice fréquenciel k
;param r1: l'adresse du signal
;param r2: tables trigo
;return r0: partie réelle ou imaginaire de la DFT
Somme proc
	mov r3,#N
	mov r5,r0
	; On met dans R12 notre nombre pour faire le masque, qui est égal à N - 1
	mov r12,r3; r12=N-1
	sub r12,#1; r12--
	mov r4,#0; on stocke le resultat du calcul dans r4 
loop
	sub r3,#1; r3=N-1
	cmp r3,#-1	; on somme de N-1 à 0
	BEQ sortie
	ldrsh r6,[r1,r3, lsl #1]; accès à l'échantillon x(i)
	;calcul de i*k modulo N
	mul r0,r3; i*k
	and r0,r12 ;on applique le masque à R0, et on obtient r0 modulo N
	ldrsh r7,[r2,r0, lsl #1]; accès à l'entrée d'indice i*k %N de la table trigo
	mov r0,r5; restaurer la valeur de k
	mul r6,r6,r7; r6=r6*cos(...)
	add r4,r6; ; r4=r4+r6 cumul de la somme de x(i)*cos(...)
	b loop
sortie	
	mov r0,r4; mettre le résultat dans r0
	bx lr
	endp

	end