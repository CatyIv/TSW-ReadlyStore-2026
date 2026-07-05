<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.prodotto.ProdottoBean" %>
<%@ page import="model.immagine.ImmagineBean" %>
<%@ page import="model.carrello.CarrelloBean" %>
<%@ page import="model.itemcarrello.ItemCarrelloBean" %>
<%@ page import="java.util.List" %>

<% ProdottoBean libro = (ProdottoBean) request.getAttribute("libro");
    List<ImmagineBean> listaImmagini = (List<ImmagineBean>) request.getAttribute("listaImmagini");
    String immaginePrincipale = (String) request.getAttribute("immaginePrincipale");

    if(libro == null) {
        request.setAttribute("messaggioErrore", "Accesso non valido alla pagina del prodotto.");
        request.getRequestDispatcher("/erroreProdotto.jsp").forward(request, response);
    }

    boolean utenteLoggato = (session.getAttribute("utente") != null);

    CarrelloBean carrelloDettaglio = (CarrelloBean) session.getAttribute("carrello");
    int copieGiaNelCarrello = 0;
    if (carrelloDettaglio != null && carrelloDettaglio.getItems() != null) {
        for (ItemCarrelloBean item : carrelloDettaglio.getItems()) {
            if (item.getProdotto().getIsbn().equals(libro.getIsbn())) {
                copieGiaNelCarrello = item.getQuantita();
                break;
            }
        }
    }
    int copieDisponibiliEffettive = libro.getDisponibilita() - copieGiaNelCarrello;
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
        <div class="colonna-miniature">
            <%
                if (listaImmagini != null) {
                    for (ImmagineBean img : listaImmagini) {
            %>
            <img class="miniatura" src="<%= request.getContextPath() %>/img/copertine/<%= img.getUrl() %>" alt="Anteprima">
            <%
                    }
                }
            %>
        </div>
        <div class="copertina-principale">
            <img src="<%= request.getContextPath() %>/img/copertine/<%= immaginePrincipale %>" alt="<%= libro.getTitolo() %>">
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
                        <input type="number" id="quantita" name="quantita" value="<%= copieDisponibiliEffettive <= 0 ? "0" : "1" %>" min="<%= copieDisponibiliEffettive <= 0 ? "0" : "1" %>" max="<%= copieDisponibiliEffettive %>" <%= copieDisponibiliEffettive <= 0 ? "disabled" : "" %>>
                    </div>
                    <button type="submit" class="bottone-carrello" <%= copieDisponibiliEffettive <= 0 ? "disabled" : "" %> title="Aggiungi al Carrello">
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
        <div class="stato-disponibilita <%= (copieDisponibiliEffettive <= 0) ? "esaurito" : "" %>">
            <% if (libro.getDisponibilita() <= 0) { %>
            Esaurito
            <% } else if (copieDisponibiliEffettive <= 0) { %>
            Quantità massima già nel carrello (<%= libro.getDisponibilita() %> copie)
            <% } else { %>
            Disponibilità: <%= libro.getDisponibilita() %> copie
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