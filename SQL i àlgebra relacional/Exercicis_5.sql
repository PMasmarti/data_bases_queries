# EXERCICI 1:
"""Donar una sentència SQL per obtenir per cada mòdul on hi hagi despatxos, la suma de les durades 
de les assignacions finalitzades (instantFi diferent de null) a despatxos del mòdul. El resultat ha 
d'estar ordenat ascendentment pel nom del mòdul. Pel joc de proves que trobareu al fitxer adjunt, 
la sortida ha de ser:
MODUL		SUMAA
Omega		235"""

select modul, SUM(instantFi - instantInici) as SUMAA
from assignacions
where instantFi is not null
group by modul
order by modul asc

# EXERCICI 2:
"""Doneu una sentència SQL per obtenir el número i nom dels departaments que tenen 2 o més empleats 
que viuen a la mateixa ciutat. Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:
NUM_DPT		NOM_DPT
3		MARKETING"""

select distinct num_dpt, nom_dpt
from departaments d natural inner join empleats e 
group by d.num_dpt, e.ciutat_empl
having 2 <= count(*)

# EXERCICI 3:
"""Doneu una seqüència d'operacions en àlgebra relacional per obtenir el nom dels professors que o 
bé tenen un sou superior a 2500, o bé que cobren menys de 2500 i no tenen cap assignació a un despatx 
amb superfície inferior a 20.. Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:
NomProf
toni"""

A = professors(sou > 2500)
B = professors(sou < 2500)
U = professors * assignacions
C = U * despatxos 
D = C(superficie < 20)
H = B[nomProf]
J = D[nomProf]
Y = H - J
P = A[nomProf]
R = P_u_Y

# EXERCICI 4:
"""Tenint en compte l'esquema de la BD que s'adjunta, proposeu una sentència de creació de la taula 
següent: 
presentacioTFG(idEstudiant, titolTFG, dniDirector, dniPresident, dniVocal, instantPresentacio, nota)

Hi ha una fila de la taula per cada treball final de grau (TFG) que estigui pendent de ser presentat 
o que ja s'hagi presentat.

En la creació de la taula cal que tingueu en compte que:
- No hi pot haver dos TFG d'un mateix estudiant.
- Tot TFG ha de tenir un títol.
- No hi pot haver dos TFG amb el mateix títol i el mateix director.
- El director, el president i el vocal han de ser professors que existeixin a la base de dades, i tot 
TFG té sempre director, president i vocal.
- El director del TFG no pot estar en el tribunal del TFG (no pot ser ni president, ni vocal).
- El president i el vocal no poden ser el mateix professor.
- L'identificador de l'estudiant i el títol del TFG són chars de 100 caràcters.
- L'instant de presentació ha de ser un enter diferent de nul.
- La nota ha de ser un enter entre 0 i 10.
- La nota té valor nul fins que s'ha fet la presentació del TFG.

Respecteu els noms i l'ordre en què apareixen les columnes (fins i tot dins la clau o claus que calgui 
definir). Tots els noms s'han de posar en majúscues/minúscules com surt a l'enunciat."""

create table presentacioTFG
(idEstudiant char(100),
titolTFG char(100) not null,
dniDirector char(50) not null check(dniDirector <> dniVocal and dniDirector <> dniPresident),
dniPresident char(50) not null check(dniPresident <> dniVocal),
dniVocal char(50) not null,
instantPresentacio integer not null,
nota integer check(nota >= 0 and nota <= 10),
primary key (idEstudiant),
unique(titolTFG, dniDirector),
foreign key (dniDirector) references professors(dni), 
foreign key (dniPresident) references professors(dni), 
foreign key (dniVocal) references professors(dni));