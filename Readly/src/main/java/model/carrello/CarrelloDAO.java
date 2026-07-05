package model.carrello;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.ConnectionPool;
import model.prodotto.ProdottoBean;

public class CarrelloDAO {

    public CarrelloDAO() {
    }

    public CarrelloBean doRetrieveByUtente(String email) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        CarrelloBean carrello = null;

        String sql = "SELECT ID_Carrello, idUtente FROM Carrello WHERE idUtente = ?";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, email);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                carrello = new CarrelloBean();
                carrello.setIdCarrello(resultSet.getString("ID_Carrello"));
            }
        } finally {
            try { if (resultSet != null) resultSet.close(); } finally {
                try { if (statement != null) statement.close(); } finally {
                    ConnectionPool.releaseConnection(connection);
                }
            }
        }
        return carrello;
    }

    public void doSave(CarrelloBean carrello, String emailUtente) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;

        String sql = "INSERT INTO Carrello (ID_Carrello, idUtente) VALUES (?, ?)";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, carrello.getIdCarrello());
            statement.setString(2, emailUtente);
            statement.executeUpdate();
        } finally {
            try { if (statement != null) statement.close(); } finally {
                ConnectionPool.releaseConnection(connection);
            }
        }
    }

    public void caricaElementiCarrello(CarrelloBean carrello) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        String sql = "SELECT c.quantita, p.ISBN, p.titolo, p.autore, p.prezzo, p.IVA, p.descrizione, " +
                "p.categoria, p.disponibilita, p.idUtentePubblica " +
                "FROM Contiene c JOIN Prodotto p ON c.ISBN_prodotto = p.ISBN " +
                "WHERE c.ID_Carrello = ?";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, carrello.getIdCarrello());
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                ProdottoBean prodotto = new ProdottoBean(
                        resultSet.getString("ISBN"),
                        resultSet.getString("titolo"),
                        resultSet.getString("autore"),
                        resultSet.getDouble("prezzo"),
                        resultSet.getInt("IVA"),
                        resultSet.getString("descrizione"),
                        resultSet.getString("categoria"),
                        resultSet.getInt("disponibilita"),
                        resultSet.getString("idUtentePubblica")
                );
                int javaQuantita = resultSet.getInt("quantita");
                carrello.aggiungiProdotto(prodotto, javaQuantita);
            }
        } finally {
            try { if (resultSet != null) resultSet.close(); } finally {
                try { if (statement != null) statement.close(); } finally {
                    ConnectionPool.releaseConnection(connection);
                }
            }
        }
    }

    public void doClear(String idCarrello) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;

        String sql = "DELETE FROM Contiene WHERE ID_Carrello = ?";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, idCarrello);
            statement.executeUpdate();
        } finally {
            try { if (statement != null) statement.close(); } finally {
                ConnectionPool.releaseConnection(connection);
            }
        }
    }
}