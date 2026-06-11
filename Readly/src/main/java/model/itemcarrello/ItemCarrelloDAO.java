package model.itemcarrello;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import model.ConnectionPool;

public class ItemCarrelloDAO {
  
    public ItemCarrelloDAO() {
    }

    public void doSave(String idCarrello, String isbn, int quantita) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        String sql = "INSERT INTO Contiene (ISBN_prodotto, ID_Carrello, quantita) VALUES (?, ?, ?)" +
                        "ON DUPLICATE KEY UPDATE quantita = quantita + ?";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, isbn);
            statement.setString(2, idCarrello);
            statement.setInt(3, quantita);
            statement.setInt(4, quantita);
            statement.executeUpdate();
        } finally {
           try { if (statement != null) statement.close(); } finally {
                ConnectionPool.releaseConnection(connection);
           }
        }      
    }

    public void doUpdate(String idCarrello, String isbn, int nuovaQuantita) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        String sql = "UPDATE Contiene SET quantita = ? WHERE ID_Carrello = ? AND ISBN_prodotto = ?";
        
        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, nuovaQuantita);
            statement.setString(2, idCarrello);
            statement.setString(3, isbn);
            statement.executeUpdate();
        } finally {
           try { if (statement != null) statement.close(); } finally {
                ConnectionPool.releaseConnection(connection);
           }
        }
    }

    public void doDelete(String idCarrello, String isbn) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        String sql = "DELETE FROM Contiene WHERE ID_Carrello = ? AND ISBN_prodotto = ?";
        
        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, idCarrello);
            statement.setString(2, isbn);
            statement.executeUpdate();
        } finally {
           try { if (statement != null) statement.close(); } finally {
                ConnectionPool.releaseConnection(connection);
           }
        }
    }
}