<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20,400,0,0" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/header.css?v=8">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/evidenziatore.css">
</head>
<body>
<div class="intestazione-sito">
    <div class="barra-superiore-intestazione">
        <div class="sinistra-superiore-intestazione"></div>
        <div class="messaggio-intestazione">
            Coltiva la mente, proteggi il pianeta!
        </div>
        <div class="icone-intestazione">
            <c:choose>
                <c:when test="${empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/LoginServlet" class="collegamento-icona" title="Accedi">
                        <span class="material-symbols-outlined">person</span>
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/AreaPersonaleServlet" class="collegamento-icona" title="Il mio account">
                        <span class="material-symbols-outlined">person</span>
                    </a>
                </c:otherwise>
            </c:choose>

            <a href="${pageContext.request.contextPath}/CarrelloServlet" class="collegamento-icona" title="Carrello">
                <span class="material-symbols-outlined">shopping_cart</span>

                <c:if test="${not empty sessionScope.carrello and not empty sessionScope.carrello.items}">
                    <c:set var="conteggioBadge" value="0" />
                    <c:forEach var="item" items="${sessionScope.carrello.items}">
                        <c:set var="conteggioBadge" value="${conteggioBadge + item.quantita}" />
                    </c:forEach>
                    <c:if test="${conteggioBadge > 0}">
                        <span class="conteggio-badge">${conteggioBadge}</span>
                    </c:if>
                </c:if>
            </a>

            <a href="${pageContext.request.contextPath}/WishlistServlet" class="collegamento-icona" title="Preferiti">
                <span class="material-symbols-outlined">bookmark</span>
            </a>
        </div>
    </div>
    <div class="barra-navigazione-intestazione">
        <div class="sezione-sinistra">
            <a href="${pageContext.request.contextPath}/CatalogoServlet" class="header-logo">
                <img src="${pageContext.request.contextPath}/img/logo.png" alt="Readly" class="logo-img">
            </a>
            <div class="contenitore-ricerca">
                <form action="CatalogoServlet" method="get" id="search-form">
                    <input type="text" name="search" id="search-box" class="input-ricerca" placeholder="Cerca..." value="${not empty requestScope.searchQuery ? requestScope.searchQuery : ''}">
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