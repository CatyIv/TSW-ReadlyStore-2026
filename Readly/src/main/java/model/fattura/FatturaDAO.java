package model.fattura;

import model.ConnectionPool;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class FatturaDAO {

    private static final String TABLE_NAME = "Fattura";

    public FatturaDAO() {
    }

    public FatturaBean doRetrieveByKey(int id) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        FatturaBean bean = null;

        String sql = "SELECT ID, metodo_pagamento, data_emissione, totale, numero_ordine FROM " + TABLE_NAME + " WHERE ID = ?";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                bean = new FatturaBean(
                        resultSet.getInt("ID"),
                        resultSet.getString("metodo_pagamento"),
                        resultSet.getTimestamp("data_emissione"),
                        resultSet.getDouble("totale"),
                        resultSet.getInt("numero_ordine")
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

    public FatturaBean doRetrieveByOrdine(int numeroOrdine) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        FatturaBean bean = null;

        String sql = "SELECT ID, metodo_pagamento, data_emissione, totale, numero_ordine FROM " + TABLE_NAME + " WHERE numero_ordine = ?";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, numeroOrdine);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                bean = new FatturaBean(
                        resultSet.getInt("ID"),
                        resultSet.getString("metodo_pagamento"),
                        resultSet.getTimestamp("data_emissione"),
                        resultSet.getDouble("totale"),
                        resultSet.getInt("numero_ordine")
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

    public List<FatturaBean> doRetrieveAll() throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<FatturaBean> fatture = new ArrayList<>();

        String sql = "SELECT ID, metodo_pagamento, data_emissione, totale, numero_ordine FROM " + TABLE_NAME;

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                fatture.add(new FatturaBean(
                        resultSet.getInt("ID"),
                        resultSet.getString("metodo_pagamento"),
                        resultSet.getTimestamp("data_emissione"),
                        resultSet.getDouble("totale"),
                        resultSet.getInt("numero_ordine")
                ));
            }
        } finally {
            try { if (resultSet != null) resultSet.close(); } finally {
                try { if (statement != null) statement.close(); } finally {
                    ConnectionPool.releaseConnection(connection);
                }
            }
        }
        return fatture;
    }

    public void doSave(FatturaBean fattura) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet generatedKeys = null;

        String sql = "INSERT INTO " + TABLE_NAME + " (metodo_pagamento, data_emissione, totale, numero_ordine) VALUES (?, ?, ?, ?)";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            statement.setString(1, fattura.getMetodoPagamento());
            statement.setTimestamp(2, fattura.getDataEmissione());
            statement.setDouble(3, fattura.getTotale());
            statement.setInt(4, fattura.getNumeroOrdine());

            int rowsAffected = statement.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("La creazione della fattura è fallita, nessuna riga modificata.");
            }

            generatedKeys = statement.getGeneratedKeys();
            if (generatedKeys.next()) {
                fattura.setId(generatedKeys.getInt(1));
            } else {
                throw new SQLException("La creazione della fattura è fallita, nessun ID ottenuto.");
            }
        } finally {
            try { if (generatedKeys != null) generatedKeys.close(); } finally {
                try { if (statement != null) statement.close(); } finally {
                    ConnectionPool.releaseConnection(connection);
                }
            }
        }
    }

    public void doUpdate(FatturaBean fattura) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;

        String sql = "UPDATE " + TABLE_NAME + " SET metodo_pagamento=?, data_emissione=?, totale=?, numero_ordine=? WHERE ID=?";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);

            statement.setString(1, fattura.getMetodoPagamento());
            statement.setTimestamp(2, fattura.getDataEmissione());
            statement.setDouble(3, fattura.getTotale());
            statement.setInt(4, fattura.getNumeroOrdine());
            statement.setInt(5, fattura.getId());

            statement.executeUpdate();
        } finally {
            try { if (statement != null) statement.close(); } finally {
                ConnectionPool.releaseConnection(connection);
            }
        }
    }

    public void doDelete(int id) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;

        String sql = "DELETE FROM " + TABLE_NAME + " WHERE ID = ?";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);

            statement.executeUpdate();
        } finally {
            try { if (statement != null) statement.close(); } finally {
                ConnectionPool.releaseConnection(connection);
            }
        }
    }
}