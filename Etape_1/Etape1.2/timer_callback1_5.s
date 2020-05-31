; ce programme est pour l'assembleur RealView (Keil)
	thumb
		
	AREA DonneeSon, DATA, READONLY
			
	area  mesdata, data, readwrite ; déclaration d'un zone pour variable ou adresse
FLAG	DCD 0	; initialisation d'une variable flag
		
	area  moncode, code, readonly
	export timer_callback
	include etat.inc
	import etat
	import Son
	import LongueurSon 
	import PeriodeSonMicroSec 	
	
		
		
GPIOB_BSRR	equ	0x40010C10	
TIM3_CCR3	equ	0x4000043C	; adresse registre PWM

timer_callback proc

; if position < taille 
;	recup l'échantillon ( je vais dans son copier l'adresse de Son dans etat.son)
;   mise a l echelle
;   sortir ech vers la pwm
; 	position ++
; fin si


;r0 : @etat
;r1 : valeur de position
;r2 : valeur de taille
;r3 : @Son
;r4 : valeur de l'échantillon

	PUSH	{r4}
	ldr		r0, =etat ; r0=@etat
	ldr		r1,[r0, #E_POS] ; r1 = position
	ldr		r2, [r0, #E_TAI] ; r2 = taille
	; if position = taille, on fait rien 
	cmp 	r1, r2
	bne		sinon ; position != taille
	b		fin
	
sinon
	
	;	recup l'échantillon
	ldr 	r3, [r0, #E_SON] ;r3 = @Son
	ldrsh	r4, [r3,r1, lsl #0x1] ; r4 = échantillon
	
	;   mise a l echelle
	add		r4, #0x8000 ; 2^15 ajout offset
	
	; on a des valeurs de 0 à 64 000 il faut les reduire pour avoir entre 0 et 720
	ldr 	r12, [r0, #E_RES] 
	mul		r4, r12 ; multiplie par la resolution
	mov		r12, #0xFFFF 
	udiv	r4, r12		; division par 2^16 - 1
	
	;   sortir ech vers la pwm		
	ldr 	r12,=TIM3_CCR3; mis @ de la sortie PWM
	str		r4, [r12]
	; 	position ++
	add		r1,#0x1
	str		r1,[r0, #E_POS]

	; fin si

fin
	POP 	{r4}
	bx		lr
	endp
	end