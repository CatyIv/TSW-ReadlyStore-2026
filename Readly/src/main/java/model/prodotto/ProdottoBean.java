package model.prodotto;

import java.io.Serializable;

public class ProdottoBean implements Serializable {
    private static final long serialVersionUID = 1L;

    private String isbn;
    private String titolo;
    private String autore;
    private double prezzo;
    private int iva;
    private String descrizione;
    private String categoria;
    private int disponibilita;
    private String idUtentePubblica;

    public ProdottoBean() {
    }

    public ProdottoBean(String isbn, String titolo, String autore, double prezzo, int iva,
                        String descrizione, String categoria, int disponibilita, String idUtentePubblica) {
        this.isbn = isbn;
        this.titolo = titolo;
        this.autore = autore;
        this.prezzo = prezzo;
        this.iva = iva;
        this.descrizione = descrizione;
        this.categoria = categoria;
        this.disponibilita = disponibilita;
        this.idUtentePubblica = idUtentePubblica;
    }

    public String getIsbn() {
        return isbn;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public String getTitolo() {
        return titolo;
    }

    public void setTitolo(String titolo) {
        this.titolo = titolo;
    }

    public String getAutore() {
        return autore;
    }

    public void setAutore(String autore) {
        this.autore = autore;
    }

    public double getPrezzo() {
        return prezzo;
    }

    public void setPrezzo(double prezzo) {
        this.prezzo = prezzo;
    }

    public int getIva() {
        return iva;
    }

    public void setIva(int iva) {
        this.iva = iva;
    }

    public String getDescrizione() {
        return descrizione;
    }

    public void setDescrizione(String descrizione) {
        this.descrizione = descrizione;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public int getDisponibilita() {
        return disponibilita;
    }

    public void setDisponibilita(int disponibilita) {
        this.disponibilita = disponibilita;
    }

    public String getIdUtentePubblica() {
        return idUtentePubblica;
    }

    public void setIdUtentePubblica(String idUtentePubblica) {
        this.idUtentePubblica = idUtentePubblica;
    }
}