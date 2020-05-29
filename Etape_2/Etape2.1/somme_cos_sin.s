;------------objectifs--------------------------------------------------------------
;calculer cos²(x)+sin²(x) dans le but de vérifier la validité du codage à virgule fixe
;les nombres stockés dans les tables trigo sont codés en virgule fixe 1.15
;cos²(x)+sin²(x) sera donc representé en virgule fixe 2.30
	thumb
	area	reset, data, readonly
	;import, export
	import TabCos; tableau contenant le cosinus de 64 angles
	import TabSin; tableau contenant le sinus des mêmes angles
	export debut
	export somme_cos_sin
	
	area reset, data, readwrite
debut
	dcd	0x20004000	; stack en fin de la zone de 20k de RAM
	area	moncode, code, readonly

;fonction somme_cos_sin
;r0:paramètre, contient l'indice d'un angle d'entrée dans les tables trigonométriques (entre 0 et 63)
;retourne dans r0 la valeur S=TabCos[r0]²+TabSin[r0]²
somme_cos_sin proc
	ldr r1,=TabCos; chargement de la table de cosinus
	ldr r2,=TabSin; chargement de la table de sinus
	ldrsh r1,[r1,r0,lsl #1]; charger TabCos[r0] (2 octets) dans r1 avec extension de signe
	ldrsh r2,[r2,r0,lsl #1]; lire TabSin[r0] (2 octets) dans r2 avec extension de signe
	smull r4,r3,r1,r1; Multiplication courte 32x32 vers 32 (cos(x)*cos(x))
	smull r6,r5,r2,r2 ;Multiplication courte 32x32 vers 32 (sin(x)*sin(x))
	add r0,r6,r4; resultat
	bx lr;
	endp

	end