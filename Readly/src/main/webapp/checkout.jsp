<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.itemcarrello.ItemCarrelloBean" %>
<%@ page import="model.carrello.CarrelloBean" %>
<%@ page import="model.immagine.ImmagineDAO" %>
<%@ page import="model.immagine.ImmagineBean" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collection" %>

<%
    List<ItemCarrelloBean> elementiCarrello = (List<ItemCarrelloBean>) request.getAttribute("elementiCarrello");
    Double totaleCarrello = (Double) request.getAttribute("totaleCarrello");

    if (elementiCarrello == null || elementiCarrello.isEmpty() || totaleCarrello == null || totaleCarrello == 0.0) {
        CarrelloBean carrelloSessione = (CarrelloBean) session.getAttribute("carrello");
        if (carrelloSessione != null && carrelloSessione.getItems() != null) {
            elementiCarrello = new ArrayList<>(carrelloSessione.getItems());
            totaleCarrello = carrelloSessione.getPrezzoTotaleComplessivo();
        }
    }

    if (elementiCarrello == null) {
        elementiCarrello = new ArrayList<>();
    }
    if (totaleCarrello == null) {
        totaleCarrello = 0.0;
    }

    int totaleCopie = 0;
    for (ItemCarrelloBean item : elementiCarrello) {
        totaleCopie += item.getQuantita();
    }

    double imponibile = totaleCarrello / 1.22;
    double quotaIva = totaleCarrello - imponibile;

    ImmagineDAO immagineDao = new ImmagineDAO();
    String errorMessage = (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <title>Checkout - Readly</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20,400,0,0" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/stylesheets/checkout.css?v=9">
</head>
<body class="page-checkout">

<jsp:include page="header.jsp" />

<main>
    <div class="checkout-page">
        <h2>Riepilogo e Conferma Ordine</h2>

        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
        <div class="error-message"><%= errorMessage %></div>
        <% } %>

        <form action="ProcessOrderServlet" method="post" id="checkoutForm" novalidate>

            <div class="section">
                <h3>Riepilogo Prodotti:</h3>
                <div class="riepilogo-prodotti-lista" style="display: flex; flex-direction: column; gap: 15px; margin-bottom: 20px;">
                    <%
                        for (ItemCarrelloBean item : elementiCarrello) {
                            if (item.getProdotto() != null) {
                                String isbn = item.getProdotto().getIsbn();
                                String nomeFileImmagine = "no-cover.png";

                                try {
                                    List<ImmagineBean> listaImmagini = immagineDao.doRetrieveByProdotto(isbn);
                                    if (listaImmagini != null && !listaImmagini.isEmpty()) {
                                        nomeFileImmagine = listaImmagini.get(0).getUrl();
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                    %>
                    <div class="prodotto-checkout-item" style="display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid #9BAE73; padding-bottom: 12px;">
                        <div style="display: flex; align-items: center; gap: 15px;">
                            <div style="width: 80px; height: 110px; background-color: #F6F0D7; border: 1px solid #9BAE73; display: flex; align-items: center; justify-content: center; overflow: hidden; border-radius: 4px;">
                                <img src="img/copertine/<%= nomeFileImmagine %>" alt="Copertina di <%= item.getProdotto().getTitolo() %>" style="max-width: 100%; max-height: 100%; object-fit: contain;">
                            </div>
                            <div style="display: flex; flex-direction: column;">
                                <span style="font-family: 'Source Sans 3', sans-serif; font-size: 20px; font-weight: bold; color: #677351;"><%= item.getProdotto().getTitolo() %></span>
                                <span style="font-size: 16px; color: #9BAE73; opacity: 0.8;"><%= item.getProdotto().getAutore() %></span>
                                <span style="font-size: 16px; color: #677351; font-weight: bold; margin-top: 4px;">Quantità: <%= item.getQuantita() %></span>
                            </div>
                        </div>
                        <span style="font-family: 'Source Sans 3', sans-serif; font-size: 22px; font-weight: bold; color: #677351;"><%= String.format("%.2f €", item.getPrezzoTotale()) %></span>
                    </div>
                    <%
                            }
                        }
                    %>
                </div>
            </div>

            <div class="section">
                <h3>Riepilogo Costi:</h3>
                <div class="checkout-riepilogo-box" style="background-color: #F6F0D7; border: 1px solid #9BAE73; padding: 15px; border-radius: 6px; display: flex; flex-direction: column; gap: 8px;">
                    <div style="display: flex; justify-content: space-between;">
                        <span>Articoli totali:</span>
                        <span><%= totaleCopie %></span>
                    </div>
                    <div style="display: flex; justify-content: space-between;">
                        <span>Prezzo (Imponibile):</span>
                        <span><%= String.format("%.2f €", imponibile) %></span>
                    </div>
                    <div style="display: flex; justify-content: space-between;">
                        <span>IVA (22%):</span>
                        <span><%= String.format("%.2f €", quotaIva) %></span>
                    </div>
                    <div style="display: flex; justify-content: space-between;">
                        <span>Spedizione:</span>
                        <span style="color: #677351; font-weight: bold;">Gratis</span>
                    </div>
                    <div style="font-family: 'Source Sans 3', sans-serif; font-size: 24px; font-weight: bold; color: #9BAE73; margin-top: 15px; border-top: 1px dashed #9BAE73; padding-top: 15px; display: flex; justify-content: space-between;">
                        <span>Totale da Pagare:</span>
                        <span><%= String.format("%.2f €", totaleCarrello) %></span>
                    </div>
                </div>
            </div>

            <div class="section">
                <h3>Dati di Spedizione:</h3>
                <div class="card-details-group" style="max-width: 100%;">
                    <div class="input-group-checkout" style="margin-bottom: 15px;">
                        <label for="destinatario">Nome e Cognome Destinatario:</label>
                        <input type="text" id="destinatario" name="destinatario">
                        <span class="error-msg" id="err-destinatario"></span>
                    </div>

                    <div class="input-group-checkout" style="margin-bottom: 15px;">
                        <label for="via">Indirizzo (Via/Piazza e Civico):</label>
                        <input type="text" id="via" name="via">
                        <span class="error-msg" id="err-via"></span>
                    </div>

                    <div style="display: flex; gap: 15px;">
                        <div class="input-group-checkout" style="flex: 2;">
                            <label for="citta">Città:</label>
                            <input type="text" id="citta" name="citta">
                            <span class="error-msg" id="err-citta"></span>
                        </div>
                        <div class="input-group-checkout" style="flex: 1;">
                            <label for="cap">CAP:</label>
                            <input type="text" id="cap" name="cap" maxlength="5">
                            <span class="error-msg" id="err-cap"></span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="section">
                <h3>Scegli Metodo di Pagamento:</h3>
                <div class="payment-methods">
                    <input type="radio" id="payment_cash" name="paymentMethod" value="cash" checked>
                    <label for="payment_cash">Contanti alla consegna</label>

                    <input type="radio" id="payment_card" name="paymentMethod" value="card">
                    <label for="payment_card">Paga con Carta</label>
                </div>

                <div id="cardDetails" class="card-details-group" style="display: none; margin-top: 15px;">
                    <h4 style="font-family: 'Source Sans 3', sans-serif; color: #677351; margin-top: 0; margin-bottom: 15px; font-size: 20px;">Dettagli Carta</h4>

                    <div class="input-group-checkout" style="margin-bottom: 15px;">
                        <label for="cardName">Nome Titolare Carta:</label>
                        <input type="text" id="cardName" name="cardName">
                        <span class="error-msg" id="err-cardName"></span>
                    </div>

                    <div class="input-group-checkout" style="margin-bottom: 15px;">
                        <label for="cardNumber">Numero Carta:</label>
                        <input type="text" id="cardNumber" name="cardNumber" placeholder="XXXX XXXX XXXX XXXX" maxlength="16">
                        <span class="error-msg" id="err-cardNumber"></span>
                    </div>

                    <div style="display: flex; gap: 15px;">
                        <div class="input-group-checkout" style="flex: 1;">
                            <label for="expiryDate">Data Scadenza:</label>
                            <input type="text" id="expiryDate" name="expiryDate" placeholder="MM/YY" maxlength="5">
                            <span class="error-msg" id="err-expiryDate"></span>
                        </div>
                        <div class="input-group-checkout" style="flex: 1;">
                            <label for="cvv">Security Code (CVV):</label>
                            <input type="text" id="cvv" name="cvv" placeholder="XXX" maxlength="3">
                            <span class="error-msg" id="err-cvv"></span>
                        </div>
                    </div>
                </div>
            </div>

            <div style="margin-top: 25px;">
                <button type="submit" class="confirm-order-btn" id="confirmOrderBtn">Conferma Ordine</button>
            </div>
        </form>
    </div>
</main>

<jsp:include page="footer.jsp" />

<script src="<%= request.getContextPath() %>/javascripts/checkout.js"></script>
</body>
</html>