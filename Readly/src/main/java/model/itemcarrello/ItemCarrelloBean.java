package model.itemcarrello;

import java.io.Serializable;

import model.prodotto.ProdottoBean;

public class ItemCarrelloBean implements Serializable {
    private static final long serialVersionUID = 1L;

    private ProdottoBean prodotto;
    private int quantita;

    public ItemCarrelloBean() {
    }

    public ItemCarrelloBean(ProdottoBean prodotto, int quantita) {
        this.prodotto = prodotto;
        this.quantita = quantita;
    }

    public ProdottoBean getProdotto() {
        return prodotto;
    }

    public void setProdotto(ProdottoBean prodotto) {
        this.prodotto = prodotto;
    }

    public int getQuantita() {
        return quantita;
    }

    public void setQuantita(int quantita) {
        this.quantita = quantita;
    }

    public double getPrezzoTotale() {
        return prodotto.getPrezzo() * quantita;
    }
}