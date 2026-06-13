package model.fattura;

import java.io.Serializable;
import java.sql.Timestamp;

public class FatturaBean implements Serializable{
    private static final long serialVersionUID = 1L;

    private int id;
    private String metodoPagamento;
    private Timestamp dataEmissione;
    private double totale;
    private int numeroOrdine;

    public FatturaBean (){

    }

    public FatturaBean (int id, String metodoPagamento, Timestamp dataEmissione, double totale, int numeroOrdine){
        this.metodoPagamento = metodoPagamento;
        this.dataEmissione = dataEmissione;
        this.totale = totale;
        this.numeroOrdine = numeroOrdine;
    }

    public int getId(){
        return id;
    }

    public void setId(int id){
        this.id = id;
    }

    public String getMetodoPagamento(){
        return metodoPagamento;
    }

    public void setMetodoPagamento(String metodoPagamento){
        this.metodoPagamento = metodoPagamento;
    }

    public Timestamp getDataEmissione() {
        return dataEmissione;
    }

    public void setDataEmissione(Timestamp dataEmissione) {
        this.dataEmissione = dataEmissione;
    }

    public double getTotale() {
        return totale;
    }

    public void setTotale(double totale) {
        this.totale = totale;
    }

    public int getNumeroOrdine() {
        return numeroOrdine;
    }

    public void setNumeroOrdine(int numeroOrdine) {
        this.numeroOrdine = numeroOrdine;
    }
}
