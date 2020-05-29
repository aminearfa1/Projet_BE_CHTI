int somme_cos_sin(int);
int main(){

	int indice=0;
		//resultat est en virgule 2.30 (1.15*1.15)
	//resultat=0x3FFF0001 en notation 2.30
	//ce qui=0.9999389657750726
	//le calcul est correct
	int resultat=somme_cos_sin(indice);
	
	return 0;
}