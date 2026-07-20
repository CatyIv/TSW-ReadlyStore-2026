<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catalogo Libri - Readly</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20,400,0,0" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/catalogo.css?v=3">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/popup.css">
</head>
<body>

<jsp:include page="header.jsp" />

<c:if test="${currentPage == 1 && not empty bannerProducts}">
    <div class="banner-slider-container">
        <button class="slider-arrow next" onclick="moveSlider(1)">&#10095;</button>

        <div class="slider-wrapper" id="sliderWrapper">
            <c:forEach var="book" items="${bannerProducts}">
                <a href="DettaglioProdottoServlet?isbn=${book.isbn}" class="slider-card-only-img">
                    <img src="${pageContext.request.contextPath}/img/copertine/${book.isbn}.jpg" alt="${book.titolo}" title="${book.titolo}">
                </a>
            </c:forEach>
        </div>
        <button class="slider-arrow prev" onclick="moveSlider(-1)">&#10094;</button>
    </div>
</c:if>

<div class="main-container">

    <aside class="filtri-sidebar">
        <h3>Filtra Catalogo</h3>
        <form action="CatalogoServlet" method="get">
            <c:if test="${not empty searchQuery}">
                <input type="hidden" name="searchQuery" value="${searchQuery}">
            </c:if>

            <div class="filtro-gruppo">
                <label for="category">Genere</label>
                <select name="category" id="category">
                    <option value="">Tutti i generi</option>
                    <c:forEach var="genere" items="${allCategories}">
                        <option value="${genere}" ${filterCategory == genere ? 'selected' : ''}>
                                ${genere}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="filtro-gruppo">
                <label>Autore</label>
                <div class="autori-container">
                    <label class="autore-opzione">
                        <input type="radio" name="autore" value="" ${empty filterAutore ? 'checked' : ''}>
                        <span>Tutti gli autori</span>
                    </label>

                    <c:forEach var="auth" items="${allAuthors}">
                        <label class="autore-opzione">
                            <input type="radio" name="autore" value="${auth}" ${filterAutore == auth ? 'checked' : ''}>
                            <span>${auth}</span>
                        </label>
                    </c:forEach>
                </div>
            </div>

            <div class="filtro-gruppo">
                <label>Prezzo (€)</label>
                <div class="prezzo-inputs">
                    <input type="number" name="minPrice" value="${filterMinPrice}" placeholder="Min" min="0" step="0.01">
                    <input type="number" name="maxPrice" value="${filterMaxPrice}" placeholder="Max" min="0" step="0.01">
                </div>
            </div>

            <button type="submit" class="btn-applica-filtri">Applica Filtri</button>
            <a href="CatalogoServlet" class="btn-reset-filtri">Azzera Filtri</a>
        </form>
    </aside>
    <div class="catalogo-contenuto">
        <main class="catalogo-grid">
            <c:choose>
                <c:when test="${empty products}">
                    <div class="nessun-risultato">
                        <span class="material-symbols-outlined">search_off</span>
                        <p>Nessun libro disponibile al momento con i filtri selezionati.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="product" items="${products}">
                        <div class="libro-card">
                            <a href="DettaglioProdottoServlet?isbn=${product.isbn}" class="immagine-box">
                                <img src="${pageContext.request.contextPath}/img/copertine/${product.isbn}.jpg" alt="${product.titolo}">
                            </a>

                            <div class="info-box">
                                <h4 class="titolo">
                                    <a href="DettaglioProdottoServlet?isbn=${product.isbn}" class="link-titolo-catalogo">
                                        ${product.titolo}
                                    </a>
                                </h4>

                                <p class="autore">
                                    <a href="${pageContext.request.contextPath}/CatalogoServlet?autore=${product.autore}" class="link-autore-catalogo">
                                        ${product.autore}
                                    </a>
                                </p>

                                <div class="prezzo">
                                    € <fmt:formatNumber value="${product.prezzo}" pattern="0.00"/>
                                </div>
                            </div>

                            <div class="azioni-box">

                                <div class="icon-buttons">
                                    <form action="CarrelloServlet" method="post">
                                        <input type="hidden" name="action" value="aggiungi">
                                        <input type="hidden" name="isbn" value="${product.isbn}">
                                        <input type="hidden" name="quantita" value="1">
                                        <button type="submit" class="btn-icon" title="Aggiungi al Carrello" data-titolo="${product.titolo}">
                                            <span class="material-symbols-outlined">shopping_cart</span>
                                        </button>
                                    </form>

                                    <form action="WishlistServlet" method="post" data-loggato="${not empty sessionScope.utente}">
                                        <input type="hidden" name="action" value="aggiungi">
                                        <input type="hidden" name="isbn" value="${product.isbn}">
                                        <button type="submit" class="btn-icon" title="Aggiungi alla Wishlist" data-titolo="${product.titolo}">
                                            <span class="material-symbols-outlined">favorite</span>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </main>

        <c:if test="${totalPages > 1}">
            <div class="paginazione">
                <c:forEach var="i" begin="1" end="${totalPages}">
                    <c:choose>
                        <c:when test="${i == currentPage}">
                            <span class="page-num attiva">${i}</span>
                        </c:when>
                        <c:otherwise>
                            <c:url var="pageUrl" value="CatalogoServlet">
                                <c:param name="page" value="${i}" />
                                <c:if test="${not empty filterCategory}"><c:param name="category" value="${filterCategory}" /></c:if>
                                <c:if test="${not empty filterMinPrice}"><c:param name="minPrice" value="${filterMinPrice}" /></c:if>
                                <c:if test="${not empty filterMaxPrice}"><c:param name="maxPrice" value="${filterMaxPrice}" /></c:if>
                                <c:if test="${not empty filterAutore}"><c:param name="autore" value="${filterAutore}" /></c:if>
                                <c:if test="${not empty searchQuery}"><c:param name="searchQuery" value="${searchQuery}" /></c:if>
                            </c:url>
                            <a href="${pageUrl}" class="page-num">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </div>
        </c:if>
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

<script src="${pageContext.request.contextPath}/javascripts/catalogo.js"></script>

</body>
</html>