# EXERCICI 1:
"""Doneu una seqüència d'operacions d'algebra relacional per obtenir els números i els noms dels departament 
situats a MADRID, que tenen algun empleat que guanya més de 200000. Pel joc de proves que trobareu al fitxer 
adjunt, la sortida ha de ser:
Num_dpt		Nom_dpt
5		VENDES"""

# C = departaments * empleats
B = C(sou>200000 and ciutat_dpt = 'MADRID')
D = B[num_dpt, nom_dpt]

# EXERCICI 2:
"""Doneu una seqüència d'operacions d'algebra relacional per obtenir el nom del departament on treballa i el 
nom del projecte on està assignat l'empleat número 2. Pel joc de proves que trobareu al fitxer adjunt, la 
sortida seria:
Nom_dpt		Nom_proj
MARKETING		IBDVID"""

A = empleats(num_empl = 2)
B = A * departaments
C = B * projectes
D = C[nom_dpt, nom_proj]

# EXERCICI 3:
"""Doneu una seqüència d'operacions de l'àlgebra relacional per obtenir el número i nom dels departaments que 
tenen dos o més empleats que viuen a ciutats diferents. Pel joc de proves que trobareu al fitxer adjunt, la 
sortida seria:
Num_dpt		Nom_dpt
3		MARKETING"""

# A = empleats * departaments
B = empleats * departaments
C = B[num_dpt, nom_dpt, ciutat_empl]
D = C{num_dpt -> num_dpt1, nom_dpt-> nom_dpt1, ciutat_empl-> ciutat_empl1}
E = A[num_dpt = num_dpt1, ciutat_empl <> ciutat_empl1]D
F = E[num_dpt, nom_dpt]

# EXERCICI 4:
"""Doneu una seqüència d'operacions d'algebra relacional per obtenir el número i nom dels departaments tals que 
tots els seus empleats viuen a MADRID. El resultat no ha d'incloure aquells departaments que no tenen cap empleat.
Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:
Num_dpt		Nom_dpt
3		MARKETING"""

# A = departaments[num_dpt, nom_dpt]
B = empleats(ciutat_empl != 'MADRID')
C = A * B
D = C[num_dpt, 
nom_dpt]
E = D * empleats
F = E[num_dpt, 
nom_dpt]
G = A - F
H = G * empleats
I = H[nom_dpt, 
num_dpt]