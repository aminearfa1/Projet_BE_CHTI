;------------objectifs--------------------------------------------------------------
;calculer cos�(x)+sin�(x) dans le but de v�rifier la validit� du codage � virgule fixe
;les nombres stock�s dans les tables trigo sont cod�s en virgule fixe 1.15
;cos�(x)+sin�(x) sera donc represent� en virgule fixe 2.30
	thumb
	area	reset, data, readonly
	;import, export
	import TabCos; tableau contenant le cosinus de 64 angles
	import TabSin; tableau contenant le sinus des m�mes angles
	export debut
	export somme_cos_sin
	
	area reset, data, readwrite
debut
	dcd	0x20004000	; stack en fin de la zone de 20k de RAM
	area	moncode, code, readonly

;fonction somme_cos_sin
;r0:param�tre, contient l'indice d'un angle d'entr�e dans les tables trigonom�triques (entre 0 et 63)
;retourne dans r0 la valeur S=TabCos[r0]�+TabSin[r0]�
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