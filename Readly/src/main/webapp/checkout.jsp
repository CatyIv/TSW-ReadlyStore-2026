<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:if var="requestVuota" test="${empty elementiCarrello or elementiCarrello.size() == 0}">
    <c:set var="elementiCarrello" value="${sessionScope.carrello.items}" />
    <c:set var="totaleCarrello" value="${sessionScope.carrello.prezzoTotaleComplessivo}" />
    <c:set var="imponibile" value="${totaleCarrello / 1.22}" />
    <c:set var="quotaIva" value="${totaleCarrello - imponibile}" />
    <c:set var="totaleCopie" value="0" />
    <c:forEach var="item" items="${elementiCarrello}">
        <c:set var="totaleCopie" value="${totaleCopie + item.quantita}" />
    </c:forEach>
</c:if>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <title>Checkout - Readly</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20,400,0,0" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/checkout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/bottone.css">
</head>
<body class="page-checkout">

<jsp:include page="header.jsp" />

<main>
    <div class="checkout-page">
        <h2>Riepilogo e Conferma Ordine</h2>

        <c:if test="${not empty errorMessage}">
            <div class="error-message">${errorMessage}</div>
        </c:if>

        <form action="ProcessOrderServlet" method="post" id="checkoutForm" novalidate>

            <div class="section">
                <h3>Riepilogo Prodotti:</h3>
                <div class="riepilogo-prodotti-lista" style="display: flex; flex-direction: column; gap: 15px; margin-bottom: 20px;">
                    <c:forEach var="item" items="${elementiCarrello}">
                        <c:if test="${not empty item.prodotto}">
                            <div class="prodotto-checkout-item" style="display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid #9BAE73; padding-bottom: 12px;">
                                <div style="display: flex; align-items: center; gap: 15px;">
                                    <div style="width: 80px; height: 110px; background-color: #F6F0D7; border: 1px solid #9BAE73; display: flex; align-items: center; justify-content: center; overflow: hidden; border-radius: 4px;">
                                        <c:set var="isbn" value="${item.prodotto.isbn}" />
                                        <img src="img/copertine/${isbn}.jpg"
                                             alt="Copertina di ${item.prodotto.titolo}"
                                             onerror="this.src='img/copertine/no-cover.png';"
                                             style="max-width: 100%; max-height: 100%; object-fit: contain;">
                                    </div>
                                    <div style="display: flex; flex-direction: column;">
                                        <span style="font-family: 'Source Sans 3', sans-serif; font-size: 20px; font-weight: bold; color: #677351;">${item.prodotto.titolo}</span>
                                        <span style="font-size: 16px; color: #9BAE73; opacity: 0.8;">${item.prodotto.autore}</span>
                                        <span style="font-size: 16px; color: #677351; font-weight: bold; margin-top: 4px;">Quantità: ${item.quantita}</span>
                                    </div>
                                </div>
                                <span style="font-family: 'Source Sans 3', sans-serif; font-size: 22px; font-weight: bold; color: #677351;">
                                    <fmt:formatNumber value="${item.prezzoTotale}" type="currency" currencySymbol="€" />
                                </span>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>

            <div class="section">
                <h3>Riepilogo Costi:</h3>
                <div class="checkout-riepilogo-box" style="background-color: #F6F0D7; border: 1px solid #9BAE73; padding: 15px; border-radius: 6px; display: flex; flex-direction: column; gap: 8px;">
                    <div style="display: flex; justify-content: space-between;">
                        <span>Articoli totali:</span>
                        <span>${not empty totaleCopie ? totaleCopie : 0}</span>
                    </div>
                    <div style="display: flex; justify-content: space-between;">
                        <span>Prezzo (Imponibile):</span>
                        <span><fmt:formatNumber value="${not empty imponibile ? imponibile : 0.0}" type="currency" currencySymbol="€" /></span>
                    </div>
                    <div style="display: flex; justify-content: space-between;">
                        <span>IVA (22%):</span>
                        <span><fmt:formatNumber value="${not empty quotaIva ? quotaIva : 0.0}" type="currency" currencySymbol="€" /></span>
                    </div>
                    <div style="display: flex; justify-content: space-between;">
                        <span>Spedizione:</span>
                        <span style="color: #677351; font-weight: bold;">Gratis</span>
                    </div>
                    <div style="font-family: 'Source Sans 3', sans-serif; font-size: 24px; font-weight: bold; color: #9BAE73; margin-top: 15px; border-top: 1px dashed #9BAE73; padding-top: 15px; display: flex; justify-content: space-between;">
                        <span>Totale da Pagare:</span>
                        <span><fmt:formatNumber value="${not empty totaleCarrello ? totaleCarrello : 0.0}" type="currency" currencySymbol="€" /></span>
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
<jsp:include page="bottone.jsp" />

<script src="${pageContext.request.contextPath}/javascripts/checkout.js"></script>
<script src="${pageContext.request.contextPath}/javascripts/bottone.js"></script>

</body>
</html>