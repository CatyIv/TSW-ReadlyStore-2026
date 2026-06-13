package model.wishlist;


import java.io.Serializable;
import java.sql.Timestamp;

public class WishlistBean implements Serializable {
    private static final long serialVersionUID = 1L;

    private String idUtente;
    private String isbnProdotto;
    private Timestamp dataAggiunta;

    public WishlistBean() {
    }

    public WishlistBean(String idUtente, String isbnProdotto, Timestamp dataAggiunta) {
        this.idUtente = idUtente;
        this.isbnProdotto = isbnProdotto;
        this.dataAggiunta = dataAggiunta;
    }

    public String getIdUtente() {
        return idUtente;
    }

    public void setIdUtente(String idUtente) {
        this.idUtente = idUtente;
    }

    public String getIsbnProdotto() {
        return isbnProdotto;
    }

    public void setIsbnProdotto(String isbnProdotto) {
        this.isbnProdotto = isbnProdotto;
    }

    public Timestamp getDataAggiunta() {
        return dataAggiunta;
    }

    public void setDataAggiunta(Timestamp dataAggiunta) {
        this.dataAggiunta = dataAggiunta;
    }
}