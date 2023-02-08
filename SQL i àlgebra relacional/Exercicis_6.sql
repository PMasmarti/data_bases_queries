# EXERCICI 1:
"""En aquest exercici es disposa de dades sobre la història d'assignació de mossos d'esquadra a 
destinacions dels Països Catalans. Aquí podeu trobar l'esquema estrella que mostra les dimensions 
en les que estan classificades aquestes dades. 

Donar per l'any 2003, el promig de mossos de l'especialitat 
Transit (de qualsevol perfil) que van ser assignats, a les poblacions de Badalona, Hospitalet, Lleida i Ponts, i 
amb el rang de Caporal i Mosso. Poseu al SELECT els atributs del nom de la poblacio, provincia i rang, seguits pel 
promig de la mesura, exactament en aquest ordre. Ordeneu el resultat ascendentment per nom població, provincia i rang. 

Utilitzant les clàusules del SQL específiques per consultes multidimensionals doneu un select el més compacte possible 
que, pel joc de proves del fitxer adjunt, generi el resultat següent:
Badalona	Barcelona	Caporal	6.00
Badalona	Barcelona	Mosso	150.00
Hospitalet	Barcelona	Caporal	8.00
Hospitalet	Barcelona	Mosso	200.00
Lleida	    Lleida	    Caporal	8.00
Lleida	    Lleida	    Mosso	200.00
Ponts	    Lleida	    Caporal	2.00
Ponts	    Lleida	    Mosso	50.00
            Barcelona	Caporal	7.00
            Barcelona	Mosso	175.00
            Lleida	    Caporal	5.00
            Lleida	    Mosso	125.00
                        Caporal	6.00
                        Mosso	150.00
                                78.00"""

select d.poblacioid, p.provincia, r.nom, avg(d.mossos) as promig
from destinacio d, poblacio p, rang r, data d2
where d.poblacioid = p.nom and d.rangid = r.nom 
                           and d.dataid = d2.id 
                           and d2.anyo = '2003' 
                           and d.especialitatid = 'Transit' 
                           and d.poblacioid in('Badalona' , 'Hospitalet', 'Lleida' ,'Ponts' )
                           and r.nom in('Caporal' ,  'Mosso')
group by rollup (r.nom, p.provincia, d.poblacioid)
order by d.poblacioid, p.provincia, r.nom

# EXERCICI 2:
"""En aquest exercici es disposa de dades sobre la història d'assignació de mossos d'esquadra a destinacions 
dels Països Catalans. Aquí podeu trobar l'esquema estrella que mostra les dimensions en les que estan classificades 
aquestes dades.

Donar per l'any 2003, la suma (d'entre tots els perfils i rangs) de mossos de l'especialitat Transit i Investigacio 
que hi ha assignats, a les poblacions de Badalona, Hospitalet, Lleida i Ponts. Poseu al SELECT els atributs del nom 
de la poblacio, comarca, provincia i especialitat, seguits de la suma de la mesura, exactament en aquest ordre. 
Ordeneu el resultat ascendentment per nom població, comarca, provincia i especialitat.

Utilitzant les clàusules del SQL específiques per consultes multidimensionals doneu un select el més compacte possible 
que, pel joc de proves del fitxer adjunt, generi el resultat següent:
nom	        comarca	    provincia	especialitatid	aggr
Badalona	Barcelones	Barcelona	Transit	        156
Hospitalet	Barcelones	Barcelona	Transit	        208
Lleida	    Segria	    Lleida	    Transit	        209
Ponts	    Noguera	    Lleida	    Transit	        52
            Barcelones	Barcelona	Transit	        364
 	        Noguera	    Lleida	    Transit	        52
 	        Segria	    Lleida	    Transit	        209
                        Barcelona	Transit	        364
 	 	                Lleida	    Transit	        261
                                    Transit	        625"""

select d.poblacioid,p.comarca, p.provincia, d.especialitatid, sum(d.mossos) as promig
from destinacio d, poblacio p, rang r, data d2
where d.poblacioid = p.nom and d.rangid = r.nom 
                           and d.dataid = d2.id
                           and d2.anyo = '2003' 
                           and d.especialitatid in('Transit', 'Investigacio') 
                           and d.poblacioid in('Badalona' , 'Hospitalet', 'Lleida' ,'Ponts' )
group by d.especialitatid, rollup (p.provincia, p.comarca, d.poblacioid)
order by d.poblacioid, p.comarca, p.provincia

# EXERCICI 3:
"""Doneu una seqüència d'operacions d'àlgebra relacional per obtenir el nom dels empleats que guanyen més que l'empleat 
amb num_empl 3. Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:
Nom_empl
-------------
JOAN
PERE"""

A = empleats(num_empl = 3)
D = A[num_empl, sou, nom_empl]
H = empleats[num_empl, sou, nom_empl]
B = D{num_empl-> num_empl1, sou -> sou1, nom_empl-> nom_empl1}
R = H[sou> sou1]B
Y = R[nom_empl]

# EXERCICI 4:
"""Donada la base de dades del fitxer adjunt en un estat on no hi ha cap fila, executeu una seqüència de sentències SQL 
d'actualització (INSERTs i/o UPDATEs) de tal manera que, un cop executades. El resultat de la consulta que s'indica a 
continuació sigui la donada i el nombre de files de la base de dades sigui mínim.

SELECT d.ciutat_dpt, COUNT(DISTINCT p.producte) AS QUANT
FROM departaments d, empleats e, projectes p
WHERE d.num_dpt = e.num_dpt AND e.num_proj = p.num_proj
GROUP BY d.ciutat_dpt
ORDER BY d.ciutat_dpt

El resultat ha de ser:

CIUTAT_DPT	QUANT
BARCELONA	2
MADRID	2"""

insert into departaments values(1, 'DPT1', null, null, 'BARCELONA');
insert into departaments values(2, 'DPT1', null, null, 'MADRID');
insert into projectes values(3, 'H', 'HOLA', 4);
insert into projectes values(4, 'H', 'ADEU', 4);
insert into empleats values(1, 'R', 1, 'B', 1, 3);
insert into empleats values(2, 'D', 1, 'B', 1, 4);
insert into empleats values(3, 'F', 1, 'B', 2, 3);
insert into empleats values(4, 'H', 1, 'B', 2, 4)