<%@ page import="model.utente.UtenteBean" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20,400,0,0" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/stylesheets/header.css?v=8">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/stylesheets/evidenziatore.css">
</head>
</head>
<body>
<div class="intestazione-sito">
    <div class="barra-superiore-intestazione">
        <div class="sinistra-superiore-intestazione"></div>
        <div class="messaggio-intestazione">
            Coltiva la mente, proteggi il pianeta!
        </div>
        <div class="icone-intestazione">
            <%
                UtenteBean user = (UtenteBean) session.getAttribute("user");
                if (user == null) {
            %>
            <a href="${pageContext.request.contextPath}/LoginServlet" class="collegamento-icona" title="Accedi">
                <span class="material-symbols-outlined">person</span>
            </a>
            <% } else { %>
            <a href="${pageContext.request.contextPath}/AreaPersonaleServlet" class="collegamento-icona" title="Il mio account">
                <span class="material-symbols-outlined">person</span>
            </a>
            <% } %>
            <a href="${pageContext.request.contextPath}/CarrelloServlet" class="collegamento-icona" title="Carrello">
                <span class="material-symbols-outlined">shopping_cart</span>
                <%
                    Integer cartCount = (Integer) session.getAttribute("cartCount");
                    if (cartCount != null && cartCount > 0) {
                %>
                <span class="conteggio-badge"><%= cartCount %></span>
                <% } %>
            </a>
            <a href="${pageContext.request.contextPath}/WishlistServlet" class="collegamento-icona" title="Preferiti">
                <span class="material-symbols-outlined">bookmark</span>
            </a>
        </div>
    </div>
    <div class="barra-navigazione-intestazione">
        <div class="sezione-sinistra">
            <a href="${pageContext.request.contextPath}//CatalogoServlet" class="header-logo">
                <img src="${pageContext.request.contextPath}/img/logo.png"
                     alt="Readly"
                     class="logo-img">
            </a>
            <div class="contenitore-ricerca">
                <form action="CatalogoServlet" method="get" id="search-form">
                    <input type="text" name="search" id="search-box" class="input-ricerca" placeholder="Cerca..." value="<%= request.getAttribute("searchQuery") != null ? (String) request.getAttribute("searchQuery") : "" %>">
                    <button type="submit" class="invia-ricerca">
                        <span class="material-symbols-outlined">search</span>
                    </button>
                </form>
                     <div id="search-results"></div>
            </div>
        </div>
        <nav class="menu-navigazione">
            <a href="${pageContext.request.contextPath}/paginaChiSiamo.jsp" class="bottone-navigazione">Chi siamo</a>
            <a href="${pageContext.request.contextPath}/contatti.jsp" class="bottone-navigazione">Contatti</a>
        </nav>
    </div>
</div>
<script src="${pageContext.request.contextPath}/javascripts/search.js"></script>

</body>
</html>