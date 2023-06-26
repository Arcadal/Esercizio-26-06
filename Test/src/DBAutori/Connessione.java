package DBAutori;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class Connessione {

    private static Connessione instance;
    public static Connection con;

    private final Properties connectionProperties;

    private String connection;
    private String dbName;
    private String user;
    private String password;
    private String url;
    
    public Connessione() throws IOException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("Driver caricato correttamente");
        } catch (ClassNotFoundException e) {
            System.out.println("Non è stato possibile caricare il driver");
            e.printStackTrace();
        }
        connectionProperties = new Properties();
        
        try {
			FileInputStream fis = new FileInputStream("C:\\Users\\Betacom\\Documents\\Workspace-Eclipse\\Test\\resources\\config.properties");
			connectionProperties.load(fis);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			System.out.println("Errore di caricamento dei file");
			e.printStackTrace();
		}
        
        this.dbName = connectionProperties.getProperty("db.name");
        this.user = connectionProperties.getProperty("db.user");
        this.password = connectionProperties.getProperty("db.password");
        this.url = connectionProperties.getProperty("db.url");
        this.connection = url + dbName;
        
        connectionProperties.put("user", user);
        connectionProperties.put("password", password);
        
    }

    public static synchronized Connessione getInstance() throws IOException {
        if (instance == null) {
            instance = new Connessione();
        }
        return instance;
    }

    public Connection getConnection() {
        try {
            con = DriverManager.getConnection(connection, connectionProperties);
            System.out.println("Connessione avvenuta");
            return con;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void closeConnection() {
        try {
            con.close();
            System.out.println("Connessione chiusa");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
