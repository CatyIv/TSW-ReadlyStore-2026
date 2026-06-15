<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.carrello.CarrelloBean" %>
<%@ page import="model.itemcarrello.ItemCarrelloBean" %>
<%@ page import="java.util.Collection" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Il Tuo Carrello - Readly</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20,400,0,0" />
    <link rel="stylesheet" type="text/css" href="stylesheets/carrello.css? v=2">
</head>
<body>
<jsp:include page="header.jsp" />

<div class="contenitore-principale-carrello" style="padding: 20px; max-width: 1200px; margin: 0 auto;">
    <h1>Carrello</h1>

    <%
        CarrelloBean carrello = (CarrelloBean) session.getAttribute("carrello");
        Collection<ItemCarrelloBean> items = (carrello != null) ? carrello.getItems() : null;

        if (items == null || items.isEmpty()) {
    %>
    <div class="carrello-vuoto">
        <h2>Il tuo carrello è attualmente vuoto!</h2>
        <p>Torna al <a href="catalogo.jsp" style="color:#677351; font-weight:bold;">Catalogo</a> per esplorare i nostri libri.</p>
    </div>
    <%
    } else {
        int totaleCopie = 0;
        for (ItemCarrelloBean item : items) {
            totaleCopie += item.getQuantita();
        }
    %>

    <div class="carrello-layout">

        <div class="libri-lista-container">
            <%
                for (ItemCarrelloBean item : items) {
            %>
            <div class="prodotto-card">
                <div class="prodotto-info-lato">
                    <div class="libro-copertina-placeholder">
                        <span>Copertina</span>
                    </div>

                    <div class="prodotto-dettagli-testo">
                        <h3><%= item.getProdotto().getTitolo() %></h3>
                        <p><%= item.getProdotto().getAutore() %></p>

                        <div class="controlli-qta-box">
                            <button class="btn-qta" onclick="aggiornaQuantita('<%= item.getProdotto().getIsbn() %>', <%= item.getQuantita() - 1 %>)">-</button>
                            <span class="qta-valore"><%= item.getQuantita() %></span>
                            <button class="btn-qta" onclick="aggiornaQuantita('<%= item.getProdotto().getIsbn() %>', <%= item.getQuantita() + 1 %>)">+</button>

                            <button class="btn-cestino" onclick="chiediConfermaElimina('<%= item.getProdotto().getIsbn() %>', '<%= item.getProdotto().getTitolo().replace("'", "\\'") %>')" title="Rimuovi elemento">
                                <img src="img/cestino.png" alt="cestino" class="btn-trash-icon">
                            </button>
                        </div>
                    </div>
                </div>

                <div class="prodotto-prezzo-lato">
                    <%= String.format("%.2f €", item.getPrezzoTotale()) %>
                </div>
            </div>
            <%
                }
            %>
        </div>

        <div class="riepilogo-container">
            <h2 class="riepilogo-titolo">Riepilogo ordine</h2>

            <div class="riepilogo-riga">
                <span>Articoli inseriti:</span>
                <span><%= totaleCopie %></span>
            </div>

            <div class="riepilogo-riga">
                <span>Spedizione:</span>
                <span>Gratis</span>
            </div>

            <div class="riepilogo-riga totale-definitivo">
                <span>Totale:</span>
                <span><%= String.format("%.2f €", carrello.getPrezzoTotaleComplessivo()) %></span>
            </div>

            <a href="checkout.jsp" class="btn-checkout-blocco">
                Procedi al Checkout
                <img src="img/shopbag.png" alt="Bag" class="btn-checkout-icon">
            </a>

            <button onclick="chiediConfermaSvuota()" class="btn-svuota-link">Svuota intero carrello</button>
        </div>

    </div>
    <%
        }
    %>
</div>

<div id="custom-confirm-overlay" class="modal-overlay">
    <div class="modal-box">
        <h3 id="modal-title"></h3>
        <p id="modal-description"></p>
        <div class="modal-buttons">
            <button id="modal-btn-action" onclick="eseguiAzioneConfermata()" class="btn-modal-conferma"></button>
            <button onclick="chiudiPopup()" class="btn-modal-annulla">Annulla</button>
        </div>
    </div>
</div>

<script src="javascripts/carrello.js"></script>
</body>
</html>