<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.carrello.CarrelloBean" %>
<%@ page import="model.itemcarrello.ItemCarrelloBean" %>
<%@ page import="model.immagine.ImmagineDAO" %>
<%@ page import="model.immagine.ImmagineBean" %>
<%@ page import="java.util.Collection" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Il Tuo Carrello - Readly</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20,400,0,0" />
    <link rel="stylesheet" type="text/css" href="stylesheets/carrello.css">
    <link rel="stylesheet" type="text/css" href="stylesheets/popup.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/bottone.css">
</head>
<body>
<jsp:include page="header.jsp" />

<div class="contenitore-principale-carrello">
    <h1>Carrello</h1>

    <%
        CarrelloBean carrello = (CarrelloBean) session.getAttribute("carrello");
        Collection<ItemCarrelloBean> items = (carrello != null) ? carrello.getItems() : null;

        if (items == null || items.isEmpty()) {
    %>
    <div class="carrello-vuoto" style="display: flex !important; flex-direction: row !important; align-items: center !important; justify-content: space-between !important; gap: 40px !important; padding: 40px 60px !important; text-align: left !important;">
        <div class="carrello-vuoto-testo" style="flex: 1 !important; text-align: center !important;">
            <h2 style="font-family: 'Source Sans 3', sans-serif; color: #677351; font-size: 36px; margin-top: 0; margin-bottom: 15px;">Il tuo carrello è attualmente vuoto!</h2>
            <p style="font-family: 'Source Sans 3', sans-serif; font-size: 18px; margin: 0; color: #9BAE73;">Torna al <a href="CatalogoServlet" style="color:#677351; font-weight:bold;">Catalogo</a> per esplorare i nostri libri.</p>
        </div>
        <div class="carrello-vuoto-immagine-box" style="flex: 1 !important; display: flex !important; justify-content: center !important; align-items: center !important;">
            <img src="img/cartVuoto.png" alt="Mascotte Carrello Vuoto" class="mascotte-vuoto-img" style="width: 100% !important; max-width: 380px !important; height: auto !important; object-fit: contain !important;">
        </div>
    </div>
    <%
    } else {
        int totaleCopie = 0;
        for (ItemCarrelloBean item : items) {
            totaleCopie += item.getQuantita();
        }

        ImmagineDAO immagineDao = new ImmagineDAO();
        boolean giaLoggato = (session.getAttribute("utente") != null || session.getAttribute("user") != null);
    %>

    <div class="carrello-layout">

        <div class="libri-lista-container">
            <%
                for (ItemCarrelloBean item : items) {
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
            <div class="prodotto-card">
                <div class="prodotto-info-lato">
                    <div class="libro-copertina-placeholder">
                        <img src="img/copertine/<%= nomeFileImmagine %>" alt="Copertina di <%= item.getProdotto().getTitolo() %>" style="max-width: 100%; max-height: 100%; object-fit: contain;">
                    </div>

                    <div class="prodotto-dettagli-testo">
                        <h3><%= item.getProdotto().getTitolo() %></h3>
                        <p><%= item.getProdotto().getAutore() %></p>

                        <div class="controlli-qta-box">
                            <button class="btn-qta" onclick="aggiornaQuantita('<%= isbn %>', <%= item.getQuantita() - 1 %>, '<%= item.getProdotto().getTitolo().replace("'", "\\'") %>', <%= item.getProdotto().getDisponibilita() %>)">-</button>
                            <span class="qta-valore"><%= item.getQuantita() %></span>
                            <button class="btn-qta" onclick="aggiornaQuantita('<%= isbn %>', <%= item.getQuantita() + 1 %>, '<%= item.getProdotto().getTitolo().replace("'", "\\'") %>', <%= item.getProdotto().getDisponibilita() %>)">+</button>

                            <button class="btn-cestino" onclick="chiediConfermaElimina('<%= isbn %>', '<%= item.getProdotto().getTitolo().replace("'", "\\'") %>')" title="Rimuovi elemento">
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

            <%
                double totaleIvato = carrello.getPrezzoTotaleComplessivo();
                double imponibile = totaleIvato / 1.22;
                double quotaIva = totaleIvato - imponibile;
            %>

            <div class="riepilogo-riga riepilogo-imponibile">
                <span>Prezzo (Imponibile):</span>
                <span><%= String.format("%.2f €", imponibile) %></span>
            </div>

            <div class="riepilogo-riga riepilogo-iva">
                <span>IVA (22%):</span>
                <span><%= String.format("%.2f €", quotaIva) %></span>
            </div>

            <div class="riepilogo-riga">
                <span>Spedizione:</span>
                <span>Gratis</span>
            </div>

            <div class="riepilogo-riga totale-definitivo">
                <span>Totale:</span>
                <span><%= String.format("%.2f €", totaleIvato) %></span>
            </div>

            <div class="riepilogo-azioni-box">
                <a href="checkout.jsp" class="btn-checkout-blocco" onclick="gestisciCheckout(event, <%= giaLoggato %>)">
                    Procedi al Checkout
                    <img src="img/shopbag.png" alt="Bag" class="btn-checkout-icon">
                </a>

                <button onclick="chiediConfermaSvuota()" class="btn-svuota-link">Svuota intero carrello</button>
            </div>

            <div class="riepilogo-mascotte-sotto">
                <img src="img/cartPieno.png" alt="Mascotte Carrello Pieno" class="mascotte-pieno-sotto-img">
            </div>
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
            <button id="modal-btn-secondary" onclick="chiudiPopup()" class="btn-modal-annulla"></button>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />
<jsp:include page="bottone.jsp" />

<script src="javascripts/carrello.js"></script>
<script src="${pageContext.request.contextPath}/javascripts/bottone.js"></script>

</body>
</html>