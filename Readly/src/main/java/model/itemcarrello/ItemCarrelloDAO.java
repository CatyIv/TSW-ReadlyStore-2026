package model.itemcarrello;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.ResultSet;

import model.ConnectionPool;

public class ItemCarrelloDAO {
  
    public ItemCarrelloDAO() {
    }

    public List<ItemCarrelloBean> doRetrieveItemsByCarrello(String idCarrello) throws SQLException {
        List<ItemCarrelloBean> items = new ArrayList<>();
        String sql = "SELECT c.quantita, p.ISBN, p.titolo, p.autore, p.prezzo, p.categoria, p.descrizione, p.disponibilita " +
                "FROM Contiene c INNER JOIN prodotto p ON c.ISBN_prodotto = p.ISBN " +
                "WHERE c.ID_Carrello = ?";

        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, idCarrello);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                model.prodotto.ProdottoBean prodotto = new model.prodotto.ProdottoBean();
                prodotto.setIsbn(resultSet.getString("ISBN"));
                prodotto.setTitolo(resultSet.getString("titolo"));
                prodotto.setAutore(resultSet.getString("autore"));
                prodotto.setPrezzo(resultSet.getDouble("prezzo"));
                prodotto.setCategoria(resultSet.getString("categoria"));
                prodotto.setDescrizione(resultSet.getString("descrizione"));
                prodotto.setDisponibilita(resultSet.getInt("disponibilita"));

                ItemCarrelloBean item = new ItemCarrelloBean(prodotto, resultSet.getInt("quantita"));
                items.add(item);
            }
        } finally {
            try {
                if (resultSet != null) resultSet.close();
            } finally {
                try {
                    if (statement != null) statement.close();
                } finally {
                    ConnectionPool.releaseConnection(connection);
                }
            }
        }
        return items;
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