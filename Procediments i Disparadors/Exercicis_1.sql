# EXERCICI 1:
"""Donat un intèrval de DNIs, programar un procediment emmagatzemat llistat_treb(dniIni,dniFi) 
per obtenir la informació de cadascun dels treballadors amb un DNI d'aquest interval. Per cada 
treballador de l'interval cal obtenir:

- Les seves dades personals: dni, nom, sou_base i plus
- En cas que el treballador tingui 5 o més lloguers actius, al llistat hi ha de sortir una fila 
per cadascun dels cotxes que té llogats.
- En qualsevol altre cas, al llistat hi ha de sortir una única fila amb les dades del treballador, 
i nul a la matrícula.

Tingueu en compte que:
- Es vol que retorneu els treballadors ordenats per dni i matricula de forma ascendent.
- El tipus de les dades que s'han de retornar han de ser els mateixos que hi ha a la taula on estan 
definits els atributs corresponents.

El procediment ha d'informar dels errors a través d'excepcions. Les situacions d'error que heu d'identificar 
són les tipificades a la taula missatgesExcepcions, que podeu trobar definida i amb els inserts corresponents 
al fitxer adjunt. En el vostre procediment heu d'incloure, on s'identifiquin aquestes situacions, les sentències:

SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=___; (1 o 2, depenent de l'error)
RAISE EXCEPTION '%',missatge;

On la variable missatge ha de ser una variable definida al vostre procediment. Pel joc de proves que trobareu al 
fitxer adjunt i la crida següent,

SELECT * FROM llistat_treb('11111111','33333333');

el resultat ha de ser:

DNI		        Nom		    Sou		    Plus    Matricula
22222222		Joan		1700		150		1111111111
22222222		Joan		1700		150		2222222222
22222222		Joan		1700		150		3333333333
22222222		Joan		1700		150		4444444444
22222222		Joan		1700		150		5555555555"""

create type treb as (dni char(8), nom char(30), sou_base real, plus real, matricula char(10));
create or replace function llistat_treb(dniIni char(8), dniFi char(8))
RETURNS setof treb AS $$
DECLARE t treb;
missatge varchar(50);
BEGIN 
	FOR t IN SELECT tr.dni, tr.nom, tr.sou_base, tr.plus 
		FROM treballadors tr
		WHERE tr.dni BETWEEN dniIni AND dniFi
		ORDER BY tr.dni
	LOOP 
		IF (t.dni IN (SELECT la.dni FROM lloguers_actius la
			WHERE t.dni = la.dni
			GROUP BY la.dni
			HAVING COUNT(*) >= 5)) THEN FOR t.matricula in select la2.matricula
											FROM lloguers_actius la2
											WHERE t.dni = la2.dni
											ORDER BY la2.matricula
			                            loop
											RETURN NEXT t;
                                            
										END LOOP;
		ELSE 										
			RETURN NEXT t;

		END IF;

	END LOOP;

	IF not found THEN 
		SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=1; 
		RAISE EXCEPTION '%',missatge; 

	END IF;

    EXCEPTION
	    WHEN raise_exception THEN raise exception '%',SQLERRM;
	    WHEN others THEN 
		    SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=2; 
		RAISE EXCEPTION '%',missatge;

END;$$LANGUAGE plpgsql;