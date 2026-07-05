<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" />
    <meta charset="UTF-8">
    <title>${libro.titolo} - Readly</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/dettaglioProdotto.css?v=11">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/popup.css">
</head>

<body>
<jsp:include page="header.jsp"/>
<div class="contenitore-dettaglio">
    <div class="sezione-immagini">
        <div class="copertina-principale">
            <img src="${pageContext.request.contextPath}/img/copertine/${libro.isbn}.jpg?v=${pageContext.session.lastAccessedTime}"
                 alt="${libro.titolo}"
                 onerror="this.src='${pageContext.request.contextPath}/img/copertine/default_book.png';">
        </div>
    </div>
    <div class="sezione-info">
        <h1 class="titolo-libro">${libro.titolo}</h1>
        <p class="autore-editore">di <strong>${libro.autore}</strong> | Categoria: ${libro.categoria}</p>
        <p class="descrizione-libro">${libro.descrizione}</p>
        <p class="prezzo-libro">€ ${libro.prezzo}</p>

        <div class="riga-bottoni-finali">
            <form action="${pageContext.request.contextPath}/CarrelloServlet" method="post" style="margin: 0;">
                <input type="hidden" name="action" value="aggiungi">
                <input type="hidden" name="isbn" value="${libro.isbn}">
                <div class="blocco-azioni">
                    <div class="selettore-quantita">
                        <label for="quantita">Quantità:</label>
                        <input type="number" id="quantita" name="quantita"
                               value="${copieDisponibiliEffettive <= 0 ? 0 : 1}"
                               min="${copieDisponibiliEffettive <= 0 ? 0 : 1}"
                               max="${copieDisponibiliEffettive}"
                        ${copieDisponibiliEffettive <= 0 ? "disabled" : ""}>
                    </div>
                    <button type="submit" class="bottone-carrello" ${copieDisponibiliEffettive <= 0 ? "disabled" : ""} title="Aggiungi al Carrello">
                        Aggiungi al carrello <span class="material-symbols-outlined">shopping_bag</span>
                    </button>
                </div>
            </form>
            <form action="${pageContext.request.contextPath}/WishlistServlet" method="post" style="margin: 0;" data-loggato="${utenteLoggato}" class="form-wishlist">
                <input type="hidden" name="action" value="aggiungi">
                <input type="hidden" name="isbn" value="${libro.isbn}">
                <button type="submit" class="bottone-wishlist" title="Aggiungi alla Wishlist">
                    <span class="material-symbols-outlined">bookmark</span>
                </button>
            </form>
        </div>
        <div class="stato-disponibilita ${copieDisponibiliEffettive <= 0 ? 'esaurito' : ''}">
            <c:choose>
                <c:when test="${libro.disponibilita <= 0}">
                    Esaurito
                </c:when>
                <c:when test="${copieDisponibiliEffettive <= 0}">
                    Quantità massima già nel carrello (${libro.disponibilita} copie)
                </c:when>
                <c:otherwise>
                    Disponibilità: ${libro.disponibilita} copie
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<div id="success-popup-overlay" class="modal-overlay">
    <div class="modal-box">
        <h3 id="success-modal-title"></h3>
        <p id="success-modal-description"></p>
        <div class="modal-buttons">
            <button onclick="chiudiPopupSuccesso()" class="btn-modal-conferma">Continua lo shopping</button>
        </div>
    </div>
</div>

<div id="auth-popup-overlay" class="modal-overlay" onclick="chiudiPopupAuth(event)">
    <div class="modal-box" onclick="event.stopPropagation()">
        <h3>Autenticazione Richiesta</h3>
        <p>Per salvare il libro nella tua wishlist, accedi al tuo account o creane uno nuovo.</p>
        <div class="modal-buttons">
            <a href="${pageContext.request.contextPath}/login.jsp" class="btn-modal-conferma" style="text-decoration: none; display: inline-flex; align-items: center; justify-content: center;">Accedi</a>
            <a href="${pageContext.request.contextPath}/registrazione.jsp" class="btn-modal-annulla" style="text-decoration: none; display: inline-flex; align-items: center; justify-content: center;">Registrati</a>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />

<script src="${pageContext.request.contextPath}/javascripts/dettaglioProdotto.js"></script>
</body>
</html>