package DBAutori;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class Es_26_06_2023 {

	public static void main (String[] args) throws IOException{
		get_age_by_autore("Italia");
	}
	
	
	public static void get_age_by_autore(String nazione) throws IOException {
		
		List <Autore> autore = new ArrayList();
		Connessione con = new Connessione();
		Connection conn = con.getConnection();
		try  {
            CallableStatement callableStatement = conn.prepareCall("{CALL test.get_age_autori_nazione(?)}");
            
            // Imposta i parametri della procedura
            callableStatement.setString(1, nazione);
            
            // Esegui la procedura
            callableStatement.execute();
            
            // Recupera il risultato
            ResultSet resultSet = callableStatement.getResultSet();
            
            // Stampa i risultati
            
            
            while (resultSet.next()) {
            	
            	Autore autori = new Autore();
                autori.nome = resultSet.getString("nome");
                autori.cognome = resultSet.getString("cognome");
                autori.eta = resultSet.getInt("eta");
                
                autore.add(autori);
                
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
		for (Autore A : autore) {
			System.out.println("Nome: " + A.getNome() + ", Cognome: " + A.getCognome() + ", Eta: " + A.getEta());
		}
		
		
	}
	
}
