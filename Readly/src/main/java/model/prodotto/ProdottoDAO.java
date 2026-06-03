package model.prodotto;

import model.ConnectionPool;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProdottoDAO {

    private static final String TABLE_NAME = "Prodotto";

    public ProdottoDAO() {
    }

    public ProdottoBean doRetrieveByKey(String isbn) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        ProdottoBean bean = null;

        String sql = "SELECT ISBN, titolo, autore, prezzo, IVA, descrizione, categoria, disponibilita, idUtentePubblica FROM " + TABLE_NAME + " WHERE ISBN = ?";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, isbn);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                bean = new ProdottoBean(
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
            }
        } finally {
            try { if (resultSet != null) resultSet.close(); } finally {
                try { if (statement != null) statement.close(); } finally {
                    ConnectionPool.releaseConnection(connection);
                }
            }
        }
        return bean;
    }

    public List<ProdottoBean> doRetrieveAll() throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<ProdottoBean> prodotti = new ArrayList<>();

        String sql = "SELECT ISBN, titolo, autore, prezzo, IVA, descrizione, categoria, disponibilita, idUtentePubblica FROM " + TABLE_NAME;

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                prodotti.add(new ProdottoBean(
                        resultSet.getString("ISBN"),
                        resultSet.getString("titolo"),
                        resultSet.getString("autore"),
                        resultSet.getDouble("prezzo"),
                        resultSet.getInt("IVA"),
                        resultSet.getString("descrizione"),
                        resultSet.getString("categoria"),
                        resultSet.getInt("disponibilita"),
                        resultSet.getString("idUtentePubblica")
                ));
            }
        } finally {
            try { if (resultSet != null) resultSet.close(); } finally {
                try { if (statement != null) statement.close(); } finally {
                    ConnectionPool.releaseConnection(connection);
                }
            }
        }
        return prodotti;
    }

    public void doSave(ProdottoBean prodotto) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;

        String sql = "INSERT INTO " + TABLE_NAME + " (ISBN, titolo, autore, prezzo, IVA, descrizione, categoria, disponibilita, idUtentePubblica) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);

            statement.setString(1, prodotto.getIsbn());
            statement.setString(2, prodotto.getTitolo());
            statement.setString(3, prodotto.getAutore());
            statement.setDouble(4, prodotto.getPrezzo());
            statement.setInt(5, prodotto.getIva());
            statement.setString(6, prodotto.getDescrizione());
            statement.setString(7, prodotto.getCategoria());
            statement.setInt(8, prodotto.getDisponibilita());
            statement.setString(9, prodotto.getIdUtentePubblica());

            statement.executeUpdate();
        } finally {
            try { if (statement != null) statement.close(); } finally {
                ConnectionPool.releaseConnection(connection);
            }
        }
    }

    public void doUpdate(ProdottoBean prodotto) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;

        String sql = "UPDATE " + TABLE_NAME + " SET titolo=?, autore=?, prezzo=?, IVA=?, descrizione=?, categoria=?, disponibilita=?, idUtentePubblica=? WHERE ISBN=?";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);

            statement.setString(1, prodotto.getTitolo());
            statement.setString(2, prodotto.getAutore());
            statement.setDouble(3, prodotto.getPrezzo());
            statement.setInt(4, prodotto.getIva());
            statement.setString(5, prodotto.getDescrizione());
            statement.setString(6, prodotto.getCategoria());
            statement.setInt(7, prodotto.getDisponibilita());
            statement.setString(8, prodotto.getIdUtentePubblica());
            statement.setString(9, prodotto.getIsbn());

            statement.executeUpdate();
        } finally {
            try { if (statement != null) statement.close(); } finally {
                ConnectionPool.releaseConnection(connection);
            }
        }
    }

    public void doDelete(String isbn) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;

        String sql = "DELETE FROM " + TABLE_NAME + " WHERE ISBN = ?";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, isbn);

            statement.executeUpdate();
        } finally {
            try { if (statement != null) statement.close(); } finally {
                ConnectionPool.releaseConnection(connection);
            }
        }
    }
}