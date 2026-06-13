package model.ordine;

import model.ConnectionPool;
import model.prodotto.ProdottoBean;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class OrdineDAO {

    private static final String TABLE_NAME = "Ordine";

    public OrdineDAO() {
    }

    public OrdineBean doRetrieveByKey(int numeroOrdine) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        OrdineBean bean = null;

        String sql = "SELECT numero_ordine, data_ordine, stato_ordine, costo, indirizzo, corriere, data_consegna, idUtente FROM " + TABLE_NAME + " WHERE numero_ordine = ?";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, numeroOrdine);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                bean = new OrdineBean(
                        resultSet.getInt("numero_ordine"),
                        resultSet.getTimestamp("data_ordine"),
                        resultSet.getString("stato_ordine"),
                        resultSet.getDouble("costo"),
                        resultSet.getString("indirizzo"),
                        resultSet.getString("corriere"),
                        resultSet.getDate("data_consegna"),
                        resultSet.getString("idUtente")
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

    public List<OrdineBean> doRetrieveByUtente(String idUtente) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<OrdineBean> ordini = new ArrayList<>();

        String sql = "SELECT numero_ordine, data_ordine, stato_ordine, costo, indirizzo, corriere, data_consegna, idUtente FROM " + TABLE_NAME + " WHERE idUtente = ? ORDER BY data_ordine DESC";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, idUtente);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                ordini.add(new OrdineBean(
                        resultSet.getInt("numero_ordine"),
                        resultSet.getTimestamp("data_ordine"),
                        resultSet.getString("stato_ordine"),
                        resultSet.getDouble("costo"),
                        resultSet.getString("indirizzo"),
                        resultSet.getString("corriere"),
                        resultSet.getDate("data_consegna"),
                        resultSet.getString("idUtente")
                ));
            }
        } finally {
            try { if (resultSet != null) resultSet.close(); } finally {
                try { if (statement != null) statement.close(); } finally {
                    ConnectionPool.releaseConnection(connection);
                }
            }
        }
        return ordini;
    }

    public void doSave(OrdineBean ordine, Map<ProdottoBean, Integer> prodottiCarrello) throws SQLException {
        Connection connection = null;
        PreparedStatement orderStatement = null;
        PreparedStatement productStatement = null;
        ResultSet generatedKeys = null;

        String sqlOrder = "INSERT INTO " + TABLE_NAME + " (data_ordine, stato_ordine, costo, indirizzo, corriere, data_consegna, idUtente) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String sqlProduct = "INSERT INTO ProdottoOrdinato (numero_ordine, ISBN_prodotto, prezzo, IVA, quantita) VALUES (?, ?, ?, ?, ?)";

        try {
            connection = ConnectionPool.getConnection();

            connection.setAutoCommit(false);

            orderStatement = connection.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            orderStatement.setTimestamp(1, ordine.getDataOrdine());
            orderStatement.setString(2, ordine.getStatoOrdine());
            orderStatement.setDouble(3, ordine.getCosto());
            orderStatement.setString(4, ordine.getIndirizzo());
            orderStatement.setString(5, ordine.getCorriere());
            orderStatement.setDate(6, ordine.getDataConsegna());
            orderStatement.setString(7, ordine.getIdUtente());

            int rowsAffected = orderStatement.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Errore: Salvataggio ordine fallito.");
            }

            generatedKeys = orderStatement.getGeneratedKeys();
            int numeroOrdineGenerato = 0;
            if (generatedKeys.next()) {
                numeroOrdineGenerato = generatedKeys.getInt(1);
                ordine.setNumeroOrdine(numeroOrdineGenerato); // Aggiorniamo il bean
            } else {
                throw new SQLException("Errore: Impossibile recuperare l'ID dell'ordine.");
            }

            productStatement = connection.prepareStatement(sqlProduct);
            for (Map.Entry<ProdottoBean, Integer> entry : prodottiCarrello.entrySet()) {
                ProdottoBean prodotto = entry.getKey();
                int quantitaAcquistata = entry.getValue();

                productStatement.setInt(1, numeroOrdineGenerato);
                productStatement.setString(2, prodotto.getIsbn());
                productStatement.setDouble(3, prodotto.getPrezzo()); // Congela il prezzo corrente
                productStatement.setInt(4, prodotto.getIva());       // Congela l'IVA corrente
                productStatement.setInt(5, quantitaAcquistata);

                productStatement.addBatch(); // Aggiunge al pacchetto di esecuzione
            }

            productStatement.executeBatch(); // Esegue tutti gli inserimenti dei prodotti insieme

            connection.commit();

        } catch (SQLException e) {
            if (connection != null) {
                try {
                    connection.rollback(); // Se qualcosa fallisce, cancella tutto per sicurezza!
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (connection != null) {
                try { connection.setAutoCommit(true); } catch (SQLException e) { e.printStackTrace(); }
            }
            try { if (generatedKeys != null) generatedKeys.close(); } finally {
                try { if (orderStatement != null) orderStatement.close(); } finally {
                    try { if (productStatement != null) productStatement.close(); } finally {
                        ConnectionPool.releaseConnection(connection);
                    }
                }
            }
        }
    }

    public List<ProdottoBean> doRetrieveProdottiByOrdine(int numeroOrdine) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<ProdottoBean> prodottiOrdinati = new ArrayList<>();

        String sql = "SELECT p.ISBN, p.titolo, p.autore, po.prezzo, po.IVA, p.descrizione, p.categoria, po.quantita " +
                "FROM ProdottoOrdinato po JOIN Prodotto p ON po.ISBN_prodotto = p.ISBN " +
                "WHERE po.numero_ordine = ?";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, numeroOrdine);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                ProdottoBean p = new ProdottoBean();
                p.setIsbn(resultSet.getString("ISBN"));
                p.setTitolo(resultSet.getString("titolo"));
                p.setAutore(resultSet.getString("autore"));
                p.setPrezzo(resultSet.getDouble("prezzo")); // Prezzo storico congelato
                p.setIva(resultSet.getInt("IVA"));         // IVA storica congelata
                p.setDescrizione(resultSet.getString("descrizione"));
                p.setCategoria(resultSet.getString("categoria"));
                p.setDisponibilita(resultSet.getInt("quantita")); // Riutilizziamo temporaneamente questo campo per la quantità acquistata nell'ordine

                prodottiOrdinati.add(p);
            }
        } finally {
            try { if (resultSet != null) resultSet.close(); } finally {
                try { if (statement != null) statement.close(); } finally {
                    ConnectionPool.releaseConnection(connection);
                }
            }
        }
        return prodottiOrdinati;
    }

    public void doUpdateStato(int numeroOrdine, String nuovoStato) throws SQLException {
        Connection connection = null;
        PreparedStatement statement = null;

        String sql = "UPDATE " + TABLE_NAME + " SET stato_ordine = ? WHERE numero_ordine = ?";

        try {
            connection = ConnectionPool.getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, nuovoStato);
            statement.setInt(2, numeroOrdine);

            statement.executeUpdate();
        } finally {
            try { if (statement != null) statement.close(); } finally {
                ConnectionPool.releaseConnection(connection);
            }
        }
    }
}