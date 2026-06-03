package model.immagine;

import java.io.Serializable;

public class ImmagineBean implements Serializable {
    private static final long serialVersionUID = 1L;

    private String url;
    private int ordine;
    private String isbnProdotto;

    public ImmagineBean() {
    }

    public ImmagineBean(String url, int ordine, String isbnProdotto) {
        this.url = url;
        this.ordine = ordine;
        this.isbnProdotto = isbnProdotto;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public int getOrdine() {
        return ordine;
    }

    public void setOrdine(int ordine) {
        this.ordine = ordine;
    }

    public String getIsbnProdotto() {
        return isbnProdotto;
    }

    public void setIsbnProdotto(String isbnProdotto) {
        this.isbnProdotto = isbnProdotto;
    }
}