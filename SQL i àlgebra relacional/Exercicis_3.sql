# EXERCICI 1:
"""Doneu una sentència SQL per obtenir el nom dels professors que o bé se sap el seu número de telèfon 
(valor diferent de null) i tenen un sou superior a 2500, o bé no se sap el seu número de telèfon (valor null) 
i no tenen cap assignació a un despatx amb superfície inferior a 20. Pel joc de proves que trobareu al 
fitxer adjunt, la sortida seria:
NomProf
toni"""

select nomProf
from professors p
where p.telefon is not null and p.sou > 2500 or p.telefon is null and not exists(	
		                                                                        s   elect *
		                                                                            from assignacions a natural inner join despatxos d
		                                                                            where d.superficie < 20 and p.dni = a.dni)

# EXERCICI 2:
"""Donar una sentència SQL per obtenir els professors que tenen alguna assignació finalitzada (instantFi diferent de null) 
a un despatx amb superfície superior a 15 i que cobren un sou inferior o igual a la mitjana del sou de 
tots els professors. En el resultat de la consulta ha de sortir el dni del professor, el nom del professor, 
i el darrer instant en què el professor ha estat assignat a un despatx amb superfície superior a 15. Pel joc 
de proves que trobareu al fitxer adjunt, la sortida ha de ser:
DNI	NomProf	Darrer_instant
111	toni	344"""

select p.dni, 
p.nomprof, 
max(a.instantfi) as Darrer_instant
from professors p natural inner join assignacions a natural inner join despatxos d
where a.instantfi is not null and d.superficie > 15 and sou <= (
                                                                    select avg(sou) from professors)
group by p.dni

# EXERCICI 3:
"""Suposem la base de dades que podeu trobar al fitxer adjunt. Suposem que aquesta base de dades està en 
un estat on no hi ha cap fila. Doneu una seqüència de sentències SQL d'actualització (INSERTs i/o UPDATEs) 
sobre la taula que assignacions que violi la integritat referencial de la clau forana que referencia la 
taula Despatxos. Les sentències NOMÉS han de violar aquesta restricció."""

insert into professors values('112','marta','4666', 4000);
insert into despatxos values('omega','120',20);
insert into assignacions values('112', 'omega', '240', '355', null)

# EXERCICI 4:
"""Suposeu la base de dades que podeu trobar al fitxer adjunt. Doneu una seqüència de sentències SQL 
d'actualització (INSERTs i/o UPDATEs) de tal manera que, un cop executades, el resultat de la consulta següent 
sigui el que s'indica. El nombre de files de cada taula ha de ser el més petit possible, i hi ha d'haver com a 
màxim un professor. Per a la consulta:

Select count(*) as quant
From assignacions ass
Where ass.instantInici>50
Group by ass.instantInici
order by quant;

El resultat haurà de ser:

quant
1
2"""

insert into professors values('112','marta','4666', 4000);
insert into despatxos values('omega','120',20);
insert into despatxos values('alpha','120',20);
insert into assignacions values('112','omega','120',355,360);
insert into assignacions values('112','omega','120',361,null);
insert into assignacions values('112','alpha','120',355,null);
