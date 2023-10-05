# EXERCICI 1:
"Doneu una seqüència d'operacions d'algebra relacional per obtenir els números i els noms dels departament situats a MADRID, 
que tenen algun empleat que guanya més de 200000. Pel joc de proves que trobareu al fitxer adjunt, la sortida ha de ser:

Num_dpt		Nom_dpt
5		VENDES"

#A=DEPARTAMENTS(CIUTAT_DPT='MADRID')
B=EMPLEATS(SOU>200000)
C=A*B
R=C[NUM_DPT, NOM_DPT]

# EXERCICI 2:
"Doneu una seqüència d'operacions d'algebra relacional per obtenir el nom del departament on treballa i el nom del projecte 
on està assignat l'empleat número 2. Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

Nom_dpt		Nom_proj
MARKETING		IBDVID"

#A=EMPLEATS(NUM_EMPL=2)
B=A*DEPARTAMENTS
C=B*PROJECTES
R=C[NOM_DPT, NOM_PROJ]

# EXERCICI 3:
"Doneu una seqüència d'operacions de l'àlgebra relacional per obtenir el número i nom dels departaments que tenen dos o més 
empleats que viuen a ciutats diferents. Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

Num_dpt		Nom_dpt
3		MARKETING"

#A=DEPARTAMENTS*EMPLEATS
B=DEPARTAMENTS*EMPLEATS
C=B[NUM_DPT, NOM_DPT, CIUTAT_EMPL]
D=C{NUM_DPT -> NUM_DPT1, NOM_DPT -> NOM_DPT1, CIUTAT_EMPL -> CIUTAT_EMPL1}
E=B[NUM_DPT = NUM_DPT1, CIUTAT_EMPL <> CIUTAT_EMPL1]D
R=E[NUM_DPT, NOM_DPT]

# EXERCICI 4:
"Doneu una seqüència d'operacions d'algebra relacional per obtenir el número i nom dels departaments tals que tots els seus 
empleats viuen a MADRID. El resultat no ha d'incloure aquells departaments que no tenen cap empleat. Pel joc de proves que 
trobareu al fitxer adjunt, la sortida seria:

Num_dpt		Nom_dpt
3		MARKETING"

#A=DEPARTAMENTS*EMPLEATS
B=A(CIUTAT_EMPL != 'MADRID')
C=B[NUM_DPT, NOM_DPT, CIUTAT_EMPL]
D=DEPARTAMENTS*EMPLEATS
E=D[NUM_DPT, NOM_DPT, CIUTAT_EMPL]
F=E-C
R=F[NUM_DPT, NOM_DPT]