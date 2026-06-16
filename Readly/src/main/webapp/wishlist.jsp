<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title> Wishlist - Readly</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20,400,0,0" />
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/stylesheets/wishlist.css? v=3">
</head>
<body>

<jsp:include page="header.jsp" />

<div class="contenitore-principale-wishlist">
    <div class="wishlist-layout-verticale">
        <h1>Wishlist</h1>

        <%-- Controllo se la lista passata dalla servlet è vuota --%>
        <c:choose>
            <c:when test="${empty prodottiWishlist}">
                <div class="wishlist-vuota-wrapper">
                    <div class="wishlist-vuota">
                        <h2>La tua wishlist è vuota!</h2>
                        <p>Non hai ancora salvato nessun libro. Torna al <a href="catalogo.jsp">Catalogo</a> per aggiungerne qualcuno ai tuoi preferiti.</p>
                    </div>
                </div>
            </c:when>

            <c:otherwise>
                <div class="wishlist-griglia-prodotti">

                        <%-- Ciclo su ciascun prodotto presente nella wishlist --%>
                    <c:forEach var="prodotto" items="${prodottiWishlist}">
                        <div class="prodotto-card-wish">

                                <%-- Copertina del libro --%>
                            <div class="libro-copertina-placeholder">
                                <a href="${pageContext.request.contextPath}/DettaglioProdottoServlet?isbn=${prodotto.isbn}">
                                    <img src="${pageContext.request.contextPath}/img/copertine/${prodotto.isbn}.jpg"
                                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/img/copertine/no-cover.png';"
                                         alt="Copertina di ${prodotto.titolo}">
                                </a>
                            </div>

                                <%-- Dettagli testuali del libro --%>
                            <div class="prodotto-dettagli-testo">
                                <h3><a href="${pageContext.request.contextPath}/DettaglioProdottoServlet?isbn=${prodotto.isbn}">${prodotto.titolo}</a></h3>
                                <p class="autore-libro">${prodotto.autore}</p>
                                <p class="categoria-badge">${prodotto.categoria}</p>

                                <div class="stato-disponibilita ${prodotto.disponibilita <= 0 ? 'esaurito' : ''}">
                                    <c:choose>
                                        <c:when test="${prodotto.disponibilita > 0}">
                                            Disponibile (${prodotto.disponibilita} copie)
                                        </c:when>
                                        <c:otherwise>
                                            Momentaneamente esaurito
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                                <%-- Prezzo e Azioni --%>
                            <div class="prodotto-azioni-lato">
                                <div class="prezzo-wish">${prodotto.prezzo} €</div>

                                <div class="blocco-pulsanti">
                                        <%-- Bottone Sposta nel Carrello (Invia i dati alla CarrelloServlet) --%>
                                    <form action="${pageContext.request.contextPath}/CarrelloServlet" method="post" style="margin: 0;">
                                        <input type="hidden" name="action" value="aggiungi">
                                        <input type="hidden" name="isbn" value="${prodotto.isbn}">
                                        <input type="hidden" name="quantita" value="1">
                                        <button type="submit" class="btn-aggiungi-carrello" ${prodotto.disponibilita <= 0 ? 'disabled' : ''}>
                                            Aggiungi <span class="material-symbols-outlined">shopping_bag</span>
                                        </button>
                                    </form>

                                        <%-- Bottone Rimuovi dalla Wishlist --%>
                                    <form action="${pageContext.request.contextPath}/WishlistServlet" method="post" style="margin: 0;">
                                        <input type="hidden" name="action" value="rimuovi">
                                        <input type="hidden" name="isbn" value="${prodotto.isbn}">
                                        <button type="submit" class="btn-rimuovi-cuore" title="Rimuovi dai preferiti">
                                            <span class="material-symbols-outlined">delete</span>
                                        </button>
                                    </form>
                                </div>
                            </div>

                        </div>
                    </c:forEach>

                </div>

                <%-- Sezione inferiore per svuotare l'intero blocco --%>
                <div class="barra-inferiore-azioni">
                    <form action="${pageContext.request.contextPath}/WishlistServlet" method="post">
                        <input type="hidden" name="action" value="svuota">
                        <button type="submit" class="btn-svuota-wishlist">Svuota intera wishlist</button>
                    </form>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="footer.jsp" />

</body>
</html>