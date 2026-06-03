package model.immagine;

import model.ConnectionPool;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ImmagineDAO {

    private static final String TABLE_NAME = "Immagine";

    public ImmagineDAO() {
    }

    public ImmagineBean doRetrieveByKey(String url) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        ImmagineBean bean = null;

        String sql = "SELECT url, ordine, ISBN_prodotto FROM " + TABLE_NAME + " WHERE url = ?";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, url);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                bean = new ImmagineBean(
                        resultSet.getString("url"),
                        resultSet.getInt("ordine"),
                        resultSet.getString("ISBN_prodotto")
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

    public List<ImmagineBean> doRetrieveByProdotto(String isbnProdotto) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<ImmagineBean> immagini = new ArrayList<>();

        String sql = "SELECT url, ordine, ISBN_prodotto FROM " + TABLE_NAME + " WHERE ISBN_prodotto = ? ORDER BY ordine ASC";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, isbnProdotto);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                immagini.add(new ImmagineBean(
                        resultSet.getString("url"),
                        resultSet.getInt("ordine"),
                        resultSet.getString("ISBN_prodotto")
                ));
            }
        } finally {
            try { if (resultSet != null) resultSet.close(); } finally {
                try { if (statement != null) statement.close(); } finally {
                    ConnectionPool.releaseConnection(connection);
                }
            }
        }
        return immagini;
    }

    public List<ImmagineBean> doRetrieveAll() throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<ImmagineBean> immagini = new ArrayList<>();

        String sql = "SELECT url, ordine, ISBN_prodotto FROM " + TABLE_NAME;

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                immagini.add(new ImmagineBean(
                        resultSet.getString("url"),
                        resultSet.getInt("ordine"),
                        resultSet.getString("ISBN_prodotto")
                ));
            }
        } finally {
            try { if (resultSet != null) resultSet.close(); } finally {
                try { if (statement != null) statement.close(); } finally {
                    ConnectionPool.releaseConnection(connection);
                }
            }
        }
        return immagini;
    }

    public void doSave(ImmagineBean immagine) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;

        String sql = "INSERT INTO " + TABLE_NAME + " (url, ordine, ISBN_prodotto) VALUES (?, ?, ?)";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);

            statement.setString(1, immagine.getUrl());
            statement.setInt(2, immagine.getOrdine());
            statement.setString(3, immagine.getIsbnProdotto());

            statement.executeUpdate();
        } finally {
            try { if (statement != null) statement.close(); } finally {
                ConnectionPool.releaseConnection(connection);
            }
        }
    }

    public void doUpdate(ImmagineBean immagine) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;

        String sql = "UPDATE " + TABLE_NAME + " SET ordine=?, ISBN_prodotto=? WHERE url=?";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);

            statement.setInt(1, immagine.getOrdine());
            statement.setString(2, immagine.getIsbnProdotto());
            statement.setString(3, immagine.getUrl());

            statement.executeUpdate();
        } finally {
            try { if (statement != null) statement.close(); } finally {
                ConnectionPool.releaseConnection(connection);
            }
        }
    }

    public void doDelete(String url) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;

        String sql = "DELETE FROM " + TABLE_NAME + " WHERE url = ?";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, url);

            statement.executeUpdate();
        } finally {
            try { if (statement != null) statement.close(); } finally {
                ConnectionPool.releaseConnection(connection);
            }
        }
    }
}