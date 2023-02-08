import java.sql.*;
import java.util.Properties;

public class gestioProfes {
    public static void main (String args[]) {
        try {
        // carregar el driver al controlador
        Class.forName ("org.postgresql.Driver");
        System.out.println ();
        System.out.println ("Driver de PostgreSQL carregat correctament.");
        System.out.println ();


        // connectar a la base de dades
        // cal modificar el username, password i el nom de la base de dades
        // en el servidor postgresfib, SEMPRE el SSL ha de ser true
        Properties props = new Properties();
        props.setProperty("user","lluc.palou");
        props.setProperty("password","DB130703");
        props.setProperty("ssl","true");
        props.setProperty("sslfactory", "org.postgresql.ssl.NonValidatingFactory"); 
        Connection c = DriverManager.getConnection("jdbc:postgresql://postgresfib.fib.upc.es:6433/DBlluc.palou", props);
        c.setAutoCommit(false);
        System.out.println ("Connexio realitzada correctament.");
        System.out.println ();


        // canvi de l'esquema per defecte a un altre esquema
        Statement s = c.createStatement();
        s.executeUpdate("set search_path to public;");
        s.close();					
        System.out.println ("Canvi d'esquema realitzat correctament.");
        System.out.println ();
        
        // IMPLEMENTAR CONSULTA
        String[] telfsProf = {"3111", "3222", "3333", "4444"};
        
        PreparedStatement ps = c.prepareStatement("select dni, nomProf "+
                                                    "from professors "+
                                                    "where telefon = ? ;");
        String telf = null;
        
        for(String i : telfsProf) {
            ps.setString(1, i);
            ResultSet rs = ps.executeQuery();
            boolean trobat = false;

            while(rs.next()) {
                trobat = true;
                String nomProf_1 = rs.getString("nomProf");
                String dni_1 = rs.getString("dni");
                System.out.println("El professor amb dni" +dni_1+ "i nom "+nomProf_1);
            }

            if(!trobat) {
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