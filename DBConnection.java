package com.bakery.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
	// Standard local MySQL database credentials
    private static final String URL = "jdbc:mysql://localhost:3306/bakery_db?useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = ""; // Update this with your MySQL password

    /**
     * Establishes a connection to the MySQL database.
     * @return Connection object if successful, null otherwise.
     */
    public static Connection getConnection() {
        Connection conn = null;
        try {
            // Register the MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Open the connection
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            System.err.println("Error: MySQL JDBC Driver not found inside WEB-INF/lib.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Error: Failed to connect to the local MySQL server.");
            e.printStackTrace();
        }
        return conn;
    }
}
