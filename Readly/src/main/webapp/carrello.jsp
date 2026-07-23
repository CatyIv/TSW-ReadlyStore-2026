<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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

    <c:choose>
        <c:when test="${empty sessionScope.carrello or empty sessionScope.carrello.items}">
            <div class="carrello-vuoto">
                <div class="carrello-vuoto-testo">
                    <h2>Il tuo carrello è attualmente vuoto!</h2>
                    <p>Torna al <a href="CatalogoServlet" class="link-catalogo">Catalogo</a> per esplorare i nostri libri.</p>
                </div>
                <div class="carrello-vuoto-immagine-box">
                    <img src="img/cartVuoto.png" alt="Mascotte Carrello Vuoto" class="mascotte-vuoto-img">
                </div>
            </div>
        </c:when>

        <c:otherwise>
            <c:set var="giaLoggato" value="${not empty sessionScope.utente or not empty sessionScope.user}" />

            <c:set var="totaleCopie" value="0" />
            <c:forEach var="item" items="${sessionScope.carrello.items}">
                <c:set var="totaleCopie" value="${totaleCopie + item.quantita}" />
            </c:forEach>

            <div class="carrello-layout">

                <div class="libri-lista-container">
                    <c:forEach var="item" items="${sessionScope.carrello.items}">
                        <div class="prodotto-card">
                            <div class="prodotto-info-lato">
                                <div class="libro-copertina-placeholder">
                                    <img src="img/copertine/${item.prodotto.isbn}.jpg"
                                         onerror="this.onerror=null; this.src='img/copertine/no-cover.png';"
                                         alt="Copertina di ${item.prodotto.titolo}">
                                </div>

                                <div class="prodotto-dettagli-testo">
                                    <h3><c:out value="${item.prodotto.titolo}" /></h3>
                                    <p><c:out value="${item.prodotto.autore}" /></p>

                                    <div class="controlli-qta-box">
                                        <button class="btn-qta" onclick="aggiornaQuantita('${item.prodotto.isbn}', '-', '${item.prodotto.titolo}', ${item.prodotto.disponibilita})">-</button>
                                        <span class="qta-valore" id="qta-${item.prodotto.isbn}">${item.quantita}</span>
                                        <button class="btn-qta" onclick="aggiornaQuantita('${item.prodotto.isbn}', '+', '${item.prodotto.titolo}', ${item.prodotto.disponibilita})">+</button>

                                        <button class="btn-cestino" onclick="chiediConfermaElimina('${item.prodotto.isbn}', '${item.prodotto.titolo}')" title="Rimuovi elemento">
                                            <img src="img/cestino.png" alt="cestino" class="btn-trash-icon">
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <div class="prodotto-prezzo-lato" id="prezzo-${item.prodotto.isbn}">
                                <fmt:formatNumber value="${item.prezzoTotale}" type="currency" currencySymbol="€" />
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <div class="riepilogo-container">
                    <h2 class="riepilogo-titolo">Riepilogo ordine</h2>

                    <div class="riepilogo-riga riepilogo-articoli">
                        <span>Articoli inseriti:</span>
                        <span><c:out value="${totaleCopie}" /></span>
                    </div>

                    <c:set var="totaleIvato" value="${sessionScope.carrello.prezzoTotaleComplessivo}" />
                    <c:set var="imponibile" value="${totaleIvato / 1.22}" />
                    <c:set var="quotaIva" value="${totaleIvato - imponibile}" />

                    <div class="riepilogo-riga riepilogo-imponibile">
                        <span>Prezzo (Imponibile):</span>
                        <span><fmt:formatNumber value="${imponibile}" type="currency" currencySymbol="€" /></span>
                    </div>

                    <div class="riepilogo-riga riepilogo-iva">
                        <span>IVA (22%):</span>
                        <span><fmt:formatNumber value="${quotaIva}" type="currency" currencySymbol="€" /></span>
                    </div>

                    <div class="riepilogo-riga">
                        <span>Spedizione:</span>
                        <span>Gratis</span>
                    </div>

                    <div class="riepilogo-riga totale-definitivo">
                        <span>Totale:</span>
                        <span><fmt:formatNumber value="${totaleIvato}" type="currency" currencySymbol="€" /></span>
                    </div>

                    <div class="riepilogo-azioni-box">
                        <a href="checkout.jsp" class="btn-checkout-blocco" onclick="gestisciCheckout(event, ${giaLoggato})">
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
        </c:otherwise>
    </c:choose>
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