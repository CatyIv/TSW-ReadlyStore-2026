package model.wishlist;

import model.ConnectionPool;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class WishlistDAO {

    private static final String TABLE_NAME = "WishList";

    public WishlistDAO() {
    }

    // METODO FONDAMENTALE: Recupera tutti gli elementi in wishlist di un singolo utente
    public List<WishlistBean> doRetrieveByUtente(String idUtente) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<WishlistBean> lista = new ArrayList<>();

        String sql = "SELECT idUtente, ISBN_prodotto, data_aggiunta FROM " + TABLE_NAME + " WHERE idUtente = ? ORDER BY data_aggiunta DESC";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, idUtente);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                lista.add(new WishlistBean(
                        resultSet.getString("idUtente"),
                        resultSet.getString("ISBN_prodotto"),
                        resultSet.getTimestamp("data_aggiunta")
                ));
            }
        } finally {
            try { if (resultSet != null) resultSet.close(); } finally {
                try { if (statement != null) statement.close(); } finally {
                    ConnectionPool.releaseConnection(connection);
                }
            }
        }
        return lista;
    }

    // Aggiunge un libro alla wishlist dell'utente
    public void doSave(WishlistBean wishlist) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;

        String sql = "INSERT INTO " + TABLE_NAME + " (idUtente, ISBN_prodotto, data_aggiunta) VALUES (?, ?, ?)";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);

            statement.setString(1, wishlist.getIdUtente());
            statement.setString(2, wishlist.getIsbnProdotto());
            statement.setTimestamp(3, wishlist.getDataAggiunta());

            statement.executeUpdate();
        } finally {
            try { if (statement != null) statement.close(); } finally {
                ConnectionPool.releaseConnection(connection);
            }
        }
    }

    // Rimuove un libro dalla wishlist dell'utente (es. click sul cuore per toglierlo)
    public void doDelete(String idUtente, String isbnProdotto) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;

        String sql = "DELETE FROM " + TABLE_NAME + " WHERE idUtente = ? AND ISBN_prodotto = ?";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, idUtente);
            statement.setString(2, isbnProdotto);

            statement.executeUpdate();
        } finally {
            try { if (statement != null) statement.close(); } finally {
                ConnectionPool.releaseConnection(connection);
            }
        }
    }
}