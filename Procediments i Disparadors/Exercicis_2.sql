# EXERCICI 1:
"""Implementar mitjançant disparadors la restricció d'integritat següent: No es pot esborrar 
l'empleat 123 ni modificar el seu número d'empleat.

Cal informar dels errors a través d'excepcions tenint en compte les situacions tipificades a 
la taula missatgesExcepcions, que podeu trobar definida (amb els inserts corresponents) al 
fitxer adjunt. Concretament en el vostre procediment heu d'incloure, quan calgui, les sentències:

SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=__; (el número que sigui, depenent de l'error)
RAISE EXCEPTION '%',missatge;

La variable missatge ha de ser una variable definida al vostre procediment, i del mateix tipus 
que l'atribut corresponent de l'esquema de la base de dades. Pel joc de proves que trobareu al 
fitxer adjunt i la instrucció:

DELETE FROM empleats WHERE nempl=123;

La sortida ha de ser:

No es pot esborrar l'empleat 123 ni modificar el seu número d'empleat"""

CREATE FUNCTION f() RETURNS trigger AS $$
	DECLARE missatge varchar(100);
	BEGIN
		IF(old.nemlp <> 123 AND TG_OP = 'UPDATE') THEN RETURN NEW;
		ELSEIF (old.nemlp <> 123 AND TG_OP = 'DELETE') THEN RETURN NULL;
		ELSE RAISE EXCEPTION '%', missatge;
		END IF;

    EXCEPTION
	    WHEN raise_exception THEN raise exception '%', SQLERRM;
	    WHEN others THEN
		    SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=1;
		    RAISE EXCEPTION '%', missatge;
END;$$LANGUAGE plpgsql;

CREATE TRIGGER restrict_before_empl

before DELETE OR UPDATE OF nempl ON empleats
for each row execute procedure f();

# EXERCICI 2:
"""Implementar mitjançant disparadors la restricció d'integritat següent: No es poden esborrar 
empleats el dijous
Tigueu en compte que:
- Les restriccions d'integritat definides a la BD (primary key, foreign key,...) es violen amb
 menys freqüència que la restricció comprovada per aquests disparadors.
- El dia de la setmana serà el que indiqui la única fila que hi ha d'haver sempre insertada a 
la taula dia. Com podreu veure en el joc de proves que trobareu al fitxer adjunt, el dia de la 
setmana és el 'dijous'. Per fer altres proves podeu modificar la fila de la taula amb el nom d'un 
altre dia de la setmana. IMPORTANT: Tant en el programa com en la base de dades poseu el nom del 
dia de la setmana en MINÚSCULES.

Cal informar dels errors a través d'excepcions tenint en compte les situacions tipificades a la 
taula missatgesExcepcions, que podeu trobar definida (amb els inserts corresponents) al fitxer 
adjunt. Concretament en el vostre procediment heu d'incloure, quan calgui, les sentències:

SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=__;(el número que sigui, depenent de l'error)
RAISE EXCEPTION '%',missatge;

La variable missatge ha de ser una variable definida al vostre procediment, i del mateix tipus que 
l'atribut corresponent de l'esquema de la base de dades. Pel joc de proves que trobareu al fitxer 
adjunt i la instrucció:

DELETE FROM empleats WHERE salari<=1000

la sortida ha de ser:

No es poden esborrar empleats el dijous"""

CREATE FUNCTION u() RETURNS trigger AS $$
	DECLARE missatge varchar(50);
	BEGIN
		IF ('dijous' NOT IN(SELECT dia FROM dia)) THEN RETURN NULL;
		ELSE
			SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=1;
			RAISE EXCEPTION '%', missatge;
		END IF;
END;$$LANGUAGE plpgsql;

CREATE TRIGGER restrict_l

before DELETE ON empleats
for each statement execute procedure u();

# EXERCICI 3:
"""En aquest exercici es tracta de mantenir de manera automàtica, mitjançant triggers, l'atribut derivat 
import de la taula comandes.

En concret, l'import d'una comanda és igual a la suma dels resultats de multiplicar per cada línia de 
comanda, la quantitat del producte de la línia pel preu del producte. 

Només heu de considerar les operacions de tipus INSERT sobre la taula línies de comandes.

Pel joc de proves que trobareu al fitxer adjunt, i la sentència: 

INSERT INTO liniesComandes VALUES (110, 'p111', 2);

La sentència s'executarà sense cap problema, i l'estat de la taula de comandes després de la seva execució 
ha de ser:
numcomanda		instantfeta		instantservida		numtelf		import
110		        1091		    1101		        null		30"""