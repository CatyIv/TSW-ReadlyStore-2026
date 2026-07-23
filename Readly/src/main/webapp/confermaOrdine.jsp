<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:useBean id="ordineDAO" class="model.ordine.OrdineDAO" scope="page" />

<c:set var="idOrdineStr" value="${param.numero_ordine}" />
<c:if test="${empty idOrdineStr}">
    <c:set var="idOrdineStr" value="${requestScope.numero_ordine}" />
</c:if>
<c:if test="${empty idOrdineStr}">
    <c:set var="idOrdineStr" value="${sessionScope.ultimoNumeroOrdine}" />
</c:if>

<c:if test="${not empty idOrdineStr}">
    <fmt:parseNumber var="idOrdine" type="number" value="${idOrdineStr}" />
    <c:set var="ordine" value="${ordineDAO.doRetrieveByKey(idOrdine)}" scope="page" />
    <c:set var="items" value="${ordineDAO.doRetrieveProdottiByOrdine(idOrdine)}" scope="page" />
</c:if>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <title>Ordine Confermato - Readly</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20,400,0,0" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/checkout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/bottone.css">
</head>
<body class="page-checkout">

<jsp:include page="header.jsp" />

<main class="main-ordine-confermato">
    <div class="box-ordine-confermato">
        <div class="conferma-testo-col">
            <h2>Grazie per il tuo acquisto!</h2>
            <p>Il tuo ordine è stato ricevuto con successo ed è in fase di elaborazione. Puoi monitorare lo stato della spedizione direttamente dalla tua area personale.</p>

            <c:if test="${not empty ordine}">
                <div class="fattura-stampa-box">
                    <h1 class="fattura-titolo-principale">Fattura</h1>

                    <div class="fattura-info-grid">
                        <div class="fattura-styled-cell">
                            <span class="cell-title">Dati Fattura</span>
                            <p>Numero Fattura: <c:out value="${ordine.numeroOrdine}" /></p>
                            <p>Data: <fmt:formatDate value="${ordine.dataOrdine}" pattern="dd/MM/yyyy"/></p>
                        </div>
                        <div class="fattura-styled-cell">
                            <span class="cell-title">Destinatario</span>
                            <p>ID Utente: <c:out value="${ordine.idUtente}" /></p>
                            <p>Corriere: <c:out value="${ordine.corriere}" /></p>
                            <p class="fattura-indirizzo-sub">Indirizzo di Spedizione:</p>
                            <p><c:out value="${ordine.indirizzo}" /></p>
                        </div>
                    </div>

                    <h2 class="fattura-sezione-titolo">Dettaglio Prodotti</h2>

                    <table class="fattura-product-table">
                        <thead>
                        <tr>
                            <th>ID Prodotto</th>
                            <th>Prodotto</th>
                            <th>Qtà</th>
                            <th>Prezzo Unit. (Lordo)</th>
                            <th>IVA</th>
                            <th>Subtotale (Ivato)</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:set var="subtotaleComplessivo" value="0.0" />
                        <c:set var="totaleIva" value="0.0" />

                        <c:forEach var="item" items="${items}">
                            <c:set var="prezzoLordoUnitario" value="${item.prezzo}" />
                            <c:set var="quantita" value="${item.disponibilita}" />
                            <c:set var="totaleItemIvato" value="${prezzoLordoUnitario * quantita}" />

                            <c:set var="subtotalItemNetto" value="${totaleItemIvato / (1.0 + (item.iva / 100.0))}" />
                            <c:set var="ivaItem" value="${totaleItemIvato - subtotalItemNetto}" />

                            <c:set var="subtotaleComplessivo" value="${subtotaleComplessivo + subtotalItemNetto}" />
                            <c:set var="totaleIva" value="${totaleIva + ivaItem}" />

                            <tr>
                                <td class="text-center"><c:out value="${item.isbn}" /></td>
                                <td><c:out value="${item.titolo}" /></td>
                                <td class="text-center"><c:out value="${quantita}" /></td>
                                <td class="text-right">€ <fmt:formatNumber value="${prezzoLordoUnitario}" pattern="#,##0.00"/></td>
                                <td class="text-center"><c:out value="${item.iva}" />%</td>
                                <td class="text-right">€ <fmt:formatNumber value="${totaleItemIvato}" pattern="#,##0.00"/></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>

                    <table class="fattura-totals-table">
                        <tbody>
                        <tr>
                            <td class="text-right label-totale">Imponibile:</td>
                            <td class="text-right value-totale">€ <fmt:formatNumber value="${subtotaleComplessivo}" pattern="#,##0.00"/></td>
                        </tr>
                        <tr>
                            <td class="text-right label-totale">Totale IVA:</td>
                            <td class="text-right value-totale">€ <fmt:formatNumber value="${totaleIva}" pattern="#,##0.00"/></td>
                        </tr>
                        <tr class="riga-totale-finale">
                            <td class="text-right label-totale-bold">TOTALE FATTURA:</td>
                            <td class="text-right value-totale-bold">€ <fmt:formatNumber value="${subtotaleComplessivo + totaleIva}" pattern="#,##0.00"/></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </c:if>

            <div class="conferma-azioni-box">
                <button onclick="window.print();" class="confirm-order-btn btn-fattura-pdf">Scarica Fattura</button>
                <a href="${pageContext.request.contextPath}/CatalogoServlet" class="link-torna-catalogo">Torna al <span>Catalogo</span> per esplorare altri libri.</a>
            </div>
        </div>

        <div class="conferma-img-container">
            <img src="img/confermaOrdine.png" alt="Mascotte Ordine Confermato" class="mascotte-conferma-img">
        </div>
    </div>
</main>

<jsp:include page="footer.jsp" />
<jsp:include page="bottone.jsp" />
<script src="${pageContext.request.contextPath}/javascripts/bottone.js"></script>

</body>
</html>