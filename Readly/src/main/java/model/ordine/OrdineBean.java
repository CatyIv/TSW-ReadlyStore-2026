package model.ordine;


import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

public class OrdineBean implements Serializable {
    private static final long serialVersionUID = 1L;

    private int numeroOrdine;
    private Timestamp dataOrdine;
    private String statoOrdine;
    private double costo;
    private String indirizzo;
    private String corriere;
    private Date dataConsegna;
    private String idUtente;

    public OrdineBean() {
    }

    public OrdineBean(int numeroOrdine, Timestamp dataOrdine, String statoOrdine, double costo,
                      String indirizzo, String corriere, Date dataConsegna, String idUtente) {
        this.numeroOrdine = numeroOrdine;
        this.dataOrdine = dataOrdine;
        this.statoOrdine = statoOrdine;
        this.costo = costo;
        this.indirizzo = indirizzo;
        this.corriere = corriere;
        this.dataConsegna = dataConsegna;
        this.idUtente = idUtente;
    }

    public int getNumeroOrdine() {
        return numeroOrdine;
    }

    public void setNumeroOrdine(int numeroOrdine) {
        this.numeroOrdine = numeroOrdine;
    }

    public Timestamp getDataOrdine() {
        return dataOrdine;
    }

    public void setDataOrdine(Timestamp dataOrdine) {
        this.dataOrdine = dataOrdine;
    }

    public String getStatoOrdine() {
        return statoOrdine;
    }

    public void setStatoOrdine(String statoOrdine) {
        this.statoOrdine = statoOrdine;
    }

    public double getCosto() {
        return costo;
    }

    public void setCosto(double costo) {
        this.costo = costo;
    }

    public String getIndirizzo() {
        return indirizzo;
    }

    public void setIndirizzo(String indirizzo) {
        this.indirizzo = indirizzo;
    }

    public String getCorriere() {
        return corriere;
    }

    public void setCorriere(String corriere) {
        this.corriere = corriere;
    }

    public Date getDataConsegna() {
        return dataConsegna;
    }

    public void setDataConsegna(Date dataConsegna) {
        this.dataConsegna = dataConsegna;
    }

    public String getIdUtente() {
        return idUtente;
    }

    public void setIdUtente(String idUtente) {
        this.idUtente = idUtente;
    }
}