	
	thumb
	import	GPIO_B_set ; proc�dure de mise � 1 d'une pin, indice � passer dans R0, import�e depuis minimal_GPIOB.s
	import	GPIO_B_reset; proc�dure de mise � 0 d'une pin, indice � passer dans R0, import�e depuis minimal_GPIOB.s
	import signal ; Valeur du signal, import�e depuis main.c
	export Blabla
	export timer_callback ; Export de notre proc�dure
	area	reset, data, readonly
Blabla
	dcd	0x20004000	; stack en fin de la zone de 20k de RAM
	dcd	timer_callback	; point d'entree de notre programme
;
	area	moncode, code, readonly

timer_callback proc ; proc�dure dans laquelle on entre � chaque interruption caus�e par le timer
	push {lr} ; Empiler LR
	LDR R1, =signal ; On met l'adresse du signal dans R1
	LDR R2,[R1] ; On met la valeur du signal dans R2
	CMP R2, #0 ; On compare la valeur du signal avec 0
	BEQ Set ; Si le signal vaut 0, on se dirige vers la proc�dure Set, qui mettra le signal � 1
	BNE Reset ; Si le signal vaut 1, on se dirige vers la proc�dure Reset, qui mettra le signal � 0

Set	MOV R0, #1  ; Met R0 � 1, car on veut modifier la sortie PB1
	bl GPIO_B_set ; Met la pin PB1 � 1
	ADD R2, #1 ; Met R2 � 1, pour actualiser la valeur de Signal
	B Sortie ; Va vers la sortie du programme

Reset	MOV R0, #1 ; Met R0 � 1, car on veut modifier la sortie PB1
	bl GPIO_B_reset ; Met la pin PB1 � 0
	SUB R2, #1 ; Met R2 � 0, pour actualiser la valeur de Signal
	B Sortie ; Va vers la sortie du programme

Sortie 	LDR R1, =signal ; Met l'adresse du Signal dans R1
	STR R2,[R1] ; Actualise la valeur de Signal
	pop {pc} ; D�piler LR dans PC
	endp ; Fin de la proc�dure

	end ; Fin du programme

	

	