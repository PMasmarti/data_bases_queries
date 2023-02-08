# EXERCICI 1:
"""AQUEST EXERCICI NO ES CORREGIRÀ DE MANERA AUTOMÀTICA

PASSOS A SEGUIR

Importeu el projecte Eclipse que podeu trobar al zip adjunt
Prepareu el projecte per a ser executat (driver, dades de connexió dins del programa,...)
Prepareu la base de dades des de DBeaver (fitxers crea.txt, carrega.txt).

Apartat 1
Editeu el programa gestioProfes per tal d'implementar el bloc IMPLEMENTAR CONSULTA
En aquest bloc cal implemenar en jdbc:
Una consulta per obtenir el dni i el nom dels professors que tenen els telèfons que hi ha 
a l'array telfsProf. En cas que hi hagi un telèfon que no sigui de cap professor caldrà 
que surti el número de telèfon i el text NO TROBAT. Cal mostrar amb System.out.println el 
resultat de la consulta. Executeu el programa. Indiqueu quin és el resultat del select.

Apartat 2
Editeu el programa gestioProfes per tal d'implementar el bloc IMPLEMENTAR CANVI BD
En aquest bloc cal implemenar en jdbc:
Per cada despatx del mòdul 'omega' que no té cap assignació amb instant fi null, incrementar 
la superfície del despatx en 3 metres quadrats.
Cal mostrar amb System.out.println la quantitat de files modificades.
En cas que la superfície d'algun dels despatxos passi a ser més gran o igual a 25, no s'ha de 
modificar cap despatx, i cal mostrar un missatge Algun despatx passaria a tenir superfície 
superior o igual a 25. Indiqueu quina/es sentències SQL us ha/n fet falta per implementar el canvi, 
quin és el resultat de l'execució del programa, i com ho heu fet per identificar si es produeix l'excepció.

Escriviu la resposta a les preguntes anteriors, i el codi del programa que heu editat per a la 
implementació dels apartats 1 i 2, en el formulari del qüestionari i premeu Envia."""

Apartat 1: 
El que imprimeix el programa és això: 

El professor amb dni111                                               i nom ruth                                              
El professor amb dni222                                               i nom ona                                               
El professor amb dni333                                               i nom anna

I per tant el resultat del select és: 
dni111    ruth                                              
dni222    ona                                               
dni333    anna


Apartat 2: 

L’única sentencia SQL que ha calgut és la sentencia update següent: 
update despatxos d 
set superficie = superficie + 3 
where modul = 'omega' and not exists(
select * 
from assignacions a 
where a.modul = d.modul and a.numero = d.numero and instantFi is null) ;
Per tant s’ha fet ús de la sentència select i la sentencia update.  

El resultat de l’execució del programa és 1, que és el nombre de tuples modificades per la sentencia update. Si tornem a executar el programa per segon cop, dona l’error del check(amb hexadecimal: 23514). 
Per identificar si es produeix o no l’excepcio només cal veure que la taula ja té la restricció check següent: check(superficie>12 and superficie <25) que afecta a superficie, per tant si al fer l’update aquest check es deixa de complir, ho sabrem mitjançant la violació del check que ja esta implementada. Aquest error es pot capturar en el catch mirant si l’error correspon a 23514. 

// IMPLEMENTAR CONSULTA
        String[] telfsProf = {"3111", "3222", "3333", "4444"};
        
        PreparedStatement ps = c.prepareStatement("select dni, nomProf "+
                                                    "from professors "+
                                                    "where telefon = ? ;");
        
        for(String i : telfsProf) {
            ps.setString(1, i);
            ResultSet rs = ps.executeQuery();
            boolean trobat = false;

            if(rs.next()) {
                trobat = true;
                String nomProf_1 = rs.getString("nomProf");
                String dni_1 = rs.getString("dni");
                System.out.println("El professor amb dni" +dni_1+ "i nom "+nomProf_1);
            }

            else{
                System.out.println("NO TROBAT");
            }
       }
		   
	   // IMPLEMENTAR CANVI BD
       Statement s1 = c.createStatement();
       int numTuplesModificades = s1.executeUpdate("update despatxos d "
    		   									  +"set superficie = superficie + 3 " 
    		   									  +"where modul = 'omega' and not exists("
    		   									  +"select * "
    		   									  +"from assignacions a "
    		   									  +"where a.modul = d.modul and a.numero = d.numero and instantFi is null) ;");
       System.out.println(numTuplesModificades);

	   // Commit i desconnexio de la base de dades
	   c.commit();
	   c.close();
	   System.out.println ("Commit i desconnexio realitzats correctament.");
	   }
	
	    catch (ClassNotFoundException ce) {
	        System.out.println ("Error al carregar el driver");
        }	
	    
        catch (SQLException se) {
            if(se.getSQLState().equals("23514")) {
		   	    System.out.println("Algun despatx passaria a tenir superfície superior o igual a 25");
	   	    } else {
	   		   System.out.println ("Excepcio: ");System.out.println ();
	   		   System.out.println ("El getSQLState es: " + se.getSQLState());
	   		   System.out.println ();
	   		   System.out.println ("El getMessage es: " + se.getMessage());	
	   	   }
        }
    }
}