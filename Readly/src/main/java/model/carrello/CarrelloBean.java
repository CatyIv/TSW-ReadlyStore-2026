package model.carrello;

import java.io.Serializable;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

import model.itemcarrello.ItemCarrelloBean;
import model.prodotto.ProdottoBean;
import model.utente.UtenteBean;

public class CarrelloBean implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private String idCarrello;
    private UtenteBean utente;
    private final Map<String, ItemCarrelloBean> items;

    public CarrelloBean() {
        this.items = new LinkedHashMap<>();
    }

    public String getIdCarrello() {
        return idCarrello;
    }

    public void setIdCarrello(String idCarrello) {
        this.idCarrello = idCarrello;
    }

    public UtenteBean getUtente() {
        return utente;
    }

    public void setUtente(UtenteBean utente) {
        this.utente = utente;
    }
    
    public void aggiungiProdotto(ProdottoBean prodotto, int qta) {
        String isbn = prodotto.getIsbn();
        if(items.containsKey(isbn)) {
            ItemCarrelloBean itemEsistente = items.get(isbn);
            itemEsistente.setQuantita(itemEsistente.getQuantita() + qta);
        } else {
            items.put(isbn, new ItemCarrelloBean(prodotto, qta));
        }
    }

    public void rimuoviProdotto(String isbn) {
        items.remove(isbn);
    }

    public void modificaQuantita(String isbn, int nuovaQta) {
        if (items.containsKey(isbn)) {
            if (nuovaQta <= 0) {
                rimuoviProdotto(isbn);
            } else {
                items.get(isbn).setQuantita(nuovaQta);
            }
        }
    }

    public void svuotaCarrello() {
        items.clear();
    }

    public Collection<ItemCarrelloBean> getItems() {
        return items.values();
    }

    public double getPrezzoComplessivo() {
        double totale = 0.0;
        for (ItemCarrelloBean item : items.values()) {
            totale += item.getProdotto().getPrezzo() * item.getQuantita();
        }
        return totale;
    }
}