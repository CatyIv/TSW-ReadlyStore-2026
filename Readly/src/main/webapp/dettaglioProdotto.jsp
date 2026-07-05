<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.prodotto.ProdottoBean" %>
<%@ page import="java.util.List" %>

<%
    ProdottoBean libro = (ProdottoBean) request.getAttribute("libro");
    if(libro == null) {
        request.setAttribute("messaggioErrore", "Accesso non valido alla pagina del prodotto.");
        request.getRequestDispatcher("/erroreProdotto.jsp").forward(request, response);
    }

    boolean utenteLoggato = (session.getAttribute("utente") != null);
    long cacheBuster = System.currentTimeMillis();
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" />
    <meta charset="UTF-8">
    <title><%= libro.getTitolo() %> - Readly</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/stylesheets/dettaglioProdotto.css?v=10">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/stylesheets/popup.css">
</head>

<body>
<jsp:include page="header.jsp"/>
<div class="contenitore-dettaglio">
    <div class="sezione-immagini">
        <div class="copertina-principale">
            <img src="<%= request.getContextPath() %>/img/copertine/<%= libro.getIsbn() %>.jpg?v=<%= cacheBuster %>"
                 alt="<%= libro.getTitolo() %>"
                 onerror="this.src='<%= request.getContextPath() %>/img/copertine/default_book.png';">
        </div>
    </div>
    <div class="sezione-info">
        <h1 class="titolo-libro"><%= libro.getTitolo() %></h1>
        <p class="autore-editore">di <strong><%= libro.getAutore() %></strong> | Categoria: <%= libro.getCategoria() %></p>
        <p class="descrizione-libro"><%= libro.getDescrizione() %></p>
        <p class="prezzo-libro">€ <%= String.format("%.2f", libro.getPrezzo()) %></p>
        <div class="riga-bottoni-finali">
            <form action="<%= request.getContextPath() %>/CarrelloServlet" method="post" style="margin: 0;">
                <input type="hidden" name="action" value="aggiungi">
                <input type="hidden" name="isbn" value="<%= libro.getIsbn() %>">
                <div class="blocco-azioni">
                    <div class="selettore-quantita">
                        <label for="quantita">Quantità:</label>
                        <input type="number" id="quantita" name="quantita" value="1" min="1" max="<%= libro.getDisponibilita() %>" <%= libro.getDisponibilita() <= 0 ? "disabled" : "" %>>
                    </div>
                    <button type="submit" class="bottone-carrello" <%= libro.getDisponibilita() <= 0 ? "disabled" : "" %> title="Aggiungi al Carrello">
                        Aggiungi al carrello <span class="material-symbols-outlined">shopping_bag</span>
                    </button>
                </div>
            </form>
            <form action="<%= request.getContextPath() %>/WishlistServlet" method="post" style="margin: 0;" data-loggato="<%= utenteLoggato %>" class="form-wishlist">
                <input type="hidden" name="action" value="aggiungi">
                <input type="hidden" name="isbn" value="<%= libro.getIsbn() %>">
                <button type="submit" class="bottone-wishlist" title="Aggiungi alla Wishlist">
                    <span class="material-symbols-outlined">bookmark</span>
                </button>
            </form>
        </div>
        <div class="stato-disponibilita <%= (libro.getDisponibilita() <= 0) ? "esaurito" : "" %>">
            <% if (libro.getDisponibilita() > 0) { %>
            Disponibilità: <%= libro.getDisponibilita() %> copie
            <% } else { %>
            Esaurito
            <% } %>
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
            <a href="<%= request.getContextPath() %>/login.jsp" class="btn-modal-conferma" style="text-decoration: none; display: inline-flex; align-items: center; justify-content: center;">Accedi</a>
            <a href="<%= request.getContextPath() %>/registrazione.jsp" class="btn-modal-annulla" style="text-decoration: none; display: inline-flex; align-items: center; justify-content: center;">Registrati</a>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />

<script src="<%= request.getContextPath() %>/javascripts/dettaglioProdotto.js"></script>
</body>
</html>