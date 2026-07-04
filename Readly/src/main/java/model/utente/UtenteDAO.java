package model.utente;

import model.ConnectionPool;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UtenteDAO {

    private static final String TABLE_NAME = "Utente";

    public UtenteDAO() {
    }

    public UtenteBean doRetrieveByKey(String email) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        UtenteBean bean = null;

        String sql = "SELECT email, password, nome, cognome, telefono, Admin FROM " + TABLE_NAME + " WHERE email = ?";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, email);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                bean = new UtenteBean(
                        resultSet.getString("email"),
                        resultSet.getString("password"),
                        resultSet.getString("nome"),
                        resultSet.getString("cognome"),
                        resultSet.getString("telefono"),
                        resultSet.getBoolean("Admin")
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

    public List<UtenteBean> doRetrieveAll() throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<UtenteBean> utenti = new ArrayList<>();

        String sql = "SELECT email, password, nome, cognome, telefono, Admin FROM " + TABLE_NAME;

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                utenti.add(new UtenteBean(
                        resultSet.getString("email"),
                        resultSet.getString("password"),
                        resultSet.getString("nome"),
                        resultSet.getString("cognome"),
                        resultSet.getString("telefono"),
                        resultSet.getBoolean("Admin")
                ));
            }
        } finally {
            try { if (resultSet != null) resultSet.close(); } finally {
                try { if (statement != null) statement.close(); } finally {
                    ConnectionPool.releaseConnection(connection);
                }
            }
        }
        return utenti;
    }

    public void doSave(UtenteBean utente) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;

        String sql = "INSERT INTO " + TABLE_NAME + " (email, password, nome, cognome, telefono, Admin) VALUES (?, ?, ?, ?, ?, ?)";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);

            statement.setString(1, utente.getEmail());
            statement.setString(2, utente.getPassword());
            statement.setString(3, utente.getNome());
            statement.setString(4, utente.getCognome());
            statement.setString(5, utente.getTelefono());
            statement.setBoolean(6, utente.isAdmin());

            statement.executeUpdate();
        } finally {
            try { if (statement != null) statement.close(); } finally {
                ConnectionPool.releaseConnection(connection);
            }
        }
    }

    public void doUpdate(UtenteBean utente) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;

        String sql = "UPDATE " + TABLE_NAME + " SET password=?, nome=?, cognome=?, telefono=?, Admin=? WHERE email=?";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);

            statement.setString(1, utente.getPassword());
            statement.setString(2, utente.getNome());
            statement.setString(3, utente.getCognome());
            statement.setString(4, utente.getTelefono());
            statement.setBoolean(5, utente.isAdmin());
            statement.setString(6, utente.getEmail());

            statement.executeUpdate();
        } finally {
            try { if (statement != null) statement.close(); } finally {
                ConnectionPool.releaseConnection(connection);
            }
        }
    }

    public void doDelete(String email) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;

        String sql = "DELETE FROM " + TABLE_NAME + " WHERE email = ?";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, email);

            statement.executeUpdate();
        } finally {
            try { if (statement != null) statement.close(); } finally {
                ConnectionPool.releaseConnection(connection);
            }
        }
    }

    public UtenteBean doRetrieveByLogin(String email, String password) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        UtenteBean bean = null;

        String sql = "SELECT email, password, nome, cognome, telefono, Admin FROM " + TABLE_NAME + " WHERE email = ? AND password = ?";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, email);
            statement.setString(2, password);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                bean = new UtenteBean(
                        resultSet.getString("email"),
                        resultSet.getString("password"),
                        resultSet.getString("nome"),
                        resultSet.getString("cognome"),
                        resultSet.getString("telefono"),
                        resultSet.getBoolean("Admin")
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

    public void doUpdateAnagrafica(UtenteBean utente) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;

        String sql = "UPDATE " + TABLE_NAME + " SET nome=?, cognome=?, telefono=? WHERE email=?";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);

            statement.setString(1, utente.getNome());
            statement.setString(2, utente.getCognome());
            statement.setString(3, utente.getTelefono());
            statement.setString(4, utente.getEmail());

            statement.executeUpdate();
        } finally {
            try { if (statement != null) statement.close(); } finally {
                ConnectionPool.releaseConnection(connection);
            }
        }
    }
}