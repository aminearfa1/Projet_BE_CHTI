	thumb
	area	reset, data, readonly

	;export __Vectors
	export M2
	import TabCos
	import TabSin
	import Somme
	area	reset, data, readwrite


Blabla
	dcd	0x20004000	; stack en fin de la zone de 20k de RAM
	; point d'entree de notre programme
;
	area	moncode, code, readonly

M2 proc
	;ro -->k et r1--> l'adresse du signal
	push {lr}
	ldr r2,=TabCos
	push{r0}
	;calcul de cos*cos
	bl Somme
	mov r5,#0
	SMULL r5,r4,r0,r0; cos²
	pop{r0}
	;calcul de sin*sin
	ldr r2,=TabSin
	push{r4}
	bl Somme
	mov r6,#0
	pop{r4}
	SMULL r6,r3,r0,r0 ;Multiplication avec accumulation
	add r0,r3,r4
	pop {pc}
	endp

	end
