<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.prodotto.ProdottoBean" %>
<%@ page import="model.immagine.ImmagineBean" %>
<%@ page import="java.util.List" %>

<% ProdottoBean libro = (ProdottoBean) request.getAttribute("libro");
List<ImmagineBean> listaImmagini = (List<ImmagineBean>) request.getAttribute("listaImmagini");
String immaginePrincipale = (String) request.getAttribute("immaginePrincipale");

if(libro == null) {
    request.setAttribute("messaggioErrore", "Accesso non valido alla pagina del prodotto.");
    request.getRequestDispatcher("/erroreProdotto.jsp").forward(request, response);
}
%>

<!DOCTYPE html>
    <html lang="it">
    <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <title><%= libro.getTitolo() %> Readly</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/stylesheets/dettaglioProdotto.css">
    </head>

    <body>
 <%-- <jsp:include page="header.jsp" /> --%>
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
        <form action="<%= request.getContextPath() %>/AggiungiAlCarrelloServlet" method="post" style="margin: 0;">
            <input type="hidden" name="action" value="aggiungi">
            <input type="hidden" name="isbn" value="<%= libro.getIsbn() %>">
            <div class="blocco-azioni">
                <div class="selettore-quantita">
                    <label for="quantita">Quantità:</label>
                    <input type="number" id="quantita" name="quantita" value="1" min="1" max="<%= libro.getDisponibilita() %>" <%= libro.getDisponibilita() <= 0 ? "disabled" : "" %>>
                </div>
                <button type="submit" class="bottone-carrello" <%= libro.getDisponibilita() <= 0 ? "disabled" : "" %> title="Aggiungi al Carrello">
                    Aggiungi al carrello <span class="icona-carrello">🛒</span>
                </button>
            </div>
        </form>
        <form action="<%= request.getContextPath() %>/AggiungiAllaWishlistServlet" method="post" style="margin: 0;">
            <input type="hidden" name="isbn" value="<%= libro.getIsbn() %>">
            <button type="submit" class="bottone-wishlist" title="Aggiungi alla Wishlist">
                ❤️
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

<%-- <jsp:include page="footer.jsp" /> --%>

</body>
</html>