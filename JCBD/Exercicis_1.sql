# EXERCICI 1:
"""AQUEST EXERCICI NO ES CORREGIRÀ DE MANERA AUTOMÀTICA

PASSOS A SEGUIR

Apartat 1
Obriu Guia de Programació en JDBC. Repasseu la informació que se us ofereix en aquesta guia.
Executeu el programa Eclipse.
Importeu el projecte Eclipse que podeu trobar al zip adjunt.
Descarregueu el driver JDBC de la pàgina del curs a una carpeta de l'ordinador.
Copieu el driver de JDBC a la carpeta libraries del projecte Eclipse (es pot fer simplement 
arrossegant des d'una carpeta on el tingueu).
Repasseu el contingut de les carpetes i fitxers que es poden trobar dins del projecte Eclipse.
Prepareu la base de dades des de DBeaver Executeu les sentències SQL de creació de taules 
(fitxer crea.txt) i càrrega de files a les taules (fitxer carrega.txt).
Editeu codi del programa gestioProfes.java (carpeta src).
Poseu el nom de la vostra base de dades (LaVostraBD).
Poseu l'esquema on estan les taules (ElVostreEsquema).
Poseu el vostre username de connexió a la base de dades (ElVostreUsername, ElVostrePassword).
Comproveu que el programa no té errors.

Apartat 2
Execució 1.
Abans d'executar el programa, des del DBeaver feu select * from Professors.
Mireu el codi del programa gestioProfes per veure què fa sobre la taula Professors.
Compileu el programa.
Executeu el programa.
Des del DBeaver torneu a fer select * from Professors.
Quin ha estat l'efecte de l'execució del programa sobre la taula Professors? Perquè?

Execució 2
Editeu el programa. Substituiu la sentència "rollback" per una sentència "commit".
Compileu el programa.
Executeu el programa.
Des del DBeaver feu torneu a fer select * from Professors.
Quin ha estat l'efecte de l'execució del programa sobre la taula Professors? Perquè?

Execució 3
Executeu una altra vegada el programa.
Quina excepció es produeix?
Quin ha estat l'efecte de l'execució del programa sobre la taula Professors? Perquè?
Com podrieu fer (sense afegir accessos a la base de dades des del programa) que quan es dongui 
aquesta excepció en lloc del missatge obtingut surti El professor ja existeix?
Editeu el programa i afegiu la implementació d'aquesta excepció.

Execució 4
Esborreu la fila que el programa insereix, des del DBeaver.
Editeu el programa per tal d'implementar el bloc IMPLEMENTAR.
En aquest bloc cal implemenar en jdbc:
Una consulta per obtenir el dni i el nom dels professors que tenen el telèfon amb un número inferior 
al número de la variable buscaTelf. En cas que no hi hagi cap professor que tingui un telèfon amb 
número inferior al indicat a la variable, treure un missatge NO TROBAT.
Cal mostrar amb System.out.println el resultat de la consulta.
Executeu una altra vegada el programa.
Indiqueu quin és el resultat del select.
Doneu el codi dela part del programa des del bloc IMPLEMENTAR fins al final.

Escriviu la resposta a les preguntes anteriors en el formulari del qüestionari i premeu Envia."""

Apartat 2: execució 1
No ha passat res doncs al codi hi ha un rollback sobre la connexió, per tant els canvis no 
s’executaran. Per a que s’executin, caldria fer un c.commit(). 

Apartat 2: execució 2
Si fem el commit el que passa és que ara si que s’executa l’inserció. Doncs recordem, les 
transaccions només s’executen si es fa el commit, si no, res de la transacció s’executa, 
doncs tenim l’autocommit en fals. Concretament el canvi sobre la taula professors és la 
inserció de la professora nina amb dni 555.

Apartat 2: execució 3
Donat que a l’execució 2 , ja hem fet la mateixa inserció que estem intentant fer ara, 
és produeix un error de la primary key (unique violation), doncs la tupla que estem intentant 
inserir, és la mateixa que ja hem inserit previament (tenen ambdues mateixa PK). 

L’efecte sobre la taula professors en l’execució 3 respecte l’execució 2, és nula, no passa res, 
doncs el commit mai es fa ja que primer ha saltat l’excepció, i hem sortit del try, i hem anat 
cap el catch. 

Per fer que quan es dongui aquesta excepció en lloc del missatge obtingut surti 
El professor ja existeix, el que cal fer, és modificar el camp del catch. Concretament, 
cal afegir que si el error de duplicació de clau primaria succeeix, llavors s’imprimeixi 
el string: El professor ja existeix. Traduit a codi, aixo el que vol dir és el següent: 

if(se.getSQLState().equals("23505"))
			System.out.println("El professor ja existeix");
Afegint aquest codi al camp del catch, obtenim el que se’ns demana. Doncs 23505 és la 
codificació en hexadecimal de la excepció UNIQUE_VIOLATION que és aquella que fa referencia 
al error sobre la clau primaria prèviament esmentat. 

Apartat 2: Execucio 4
Per esborrar la fila fem un select simple i per editar el bloc IMPLEMENTAR hem fet les següents 
modificacions: 

El resultat del select són aquells professors que tenen un telefon inferior a 3334. 
I concretament són , la Ruth, la ona, i l’anna amb dnis 111, 222, i 333 respectivament. 
		   
       // IMPLEMENTAR
       // printar el dni i el nom dels professors que tenen els telefons amb numero inferior al que s indica en la variable buscaTelf
       // en cas que no hi hagi cap professor amb aquest telefon printar "NO TROBAT"     
       String buscaTelf="3334";
       Statement s_1 = c.createStatement();
       ResultSet r = s_1.executeQuery("select nomProf, dni " +
                                    "from professors " +
    		                        "where telefon < '"+buscaTelf+"';"); 
       boolean trobat = false; 
       while(r.next()) {
       trobat = true;
       String dni_1 = r.getString("dni");
       String nom_1 = r.getString("nomProf"); 
       System.out.println("El professor amb dni "+dni_1+" i nom "+nom_1);
       }
       
       if(!trobat)System.out.println ("NO TROBAT");
       
	   // Rollback i desconnexio de la base de dades
	   c.close();
	   System.out.println ("Rollback i desconnexio realitzats correctament.");
	   }
	
	catch (ClassNotFoundException ce)
	   {
	   System.out.println ("Error al carregar el driver");
	   }	
	catch (SQLException se)
	   {	
		if(se.getSQLState().equals("23505"))
		   System.out.println("El professor ja existeix");
    	System.out.println ("Excepcio: ");System.out.println ();
	    System.out.println ("El getSQLState es: " + se.getSQLState());
        System.out.println ();
	    System.out.println ("El getMessage es: " + se.getMessage());	   
	   }
  }
}

El resultat del select no és res més que tots aquells professors amb telefon menor a 3334. 
És a dir, els corresponents a:
 
'111','ruth','3111',1000
'222','ona','3222',1200
'333','anna','3333',1100