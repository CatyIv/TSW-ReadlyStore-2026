<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.ordine.OrdineBean" %>
<%@ page import="model.prodotto.ProdottoBean" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dettaglio Ordine - Readly</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Cabin:wght@700&family=Segoe+UI:wght@400;600;700&display=swap" />
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/stylesheets/auth.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/stylesheets/areaPersonale.css?v=9">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/bottone.css">
</head>
<body>

<jsp:include page="header.jsp" />

<main class="admin-main">
    <div class="admin-card">
        <%
            OrdineBean ordine = (OrdineBean) request.getAttribute("ordineDettaglio");
            List<ProdottoBean> prodottiOrdinati = (List<ProdottoBean>) request.getAttribute("prodottiOrdinati");

            if (ordine != null && prodottiOrdinati != null) {
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                String dataFormattata = (ordine.getDataOrdine() != null) ? sdf.format(ordine.getDataOrdine()) : "";
        %>
        <div class="sezione-introduzione">
            <h1 class="profile-title">Dettaglio Ordine #<%= ordine.getNumeroOrdine() %></h1>
            <p class="profile-subtitle">Effettuato il <%= dataFormattata %> | Stato: <strong><%= ordine.getStatoOrdine() %></strong></p>
        </div>

        <div class="admin-box dettaglio-riepilogo-box">
            <p class="admin-box-text dettaglio-riga-testo">Corriere assegnato: <strong><%= ordine.getCorriere() %></strong></p>
            <p class="admin-box-text dettaglio-riga-testo">Indirizzo di consegna: <strong><%= ordine.getIndirizzo() %></strong></p>
            <p class="admin-box-text dettaglio-riga-testo">Data consegna stimata/effettiva: <strong><%= (ordine.getDataConsegna() != null) ? new SimpleDateFormat("dd/MM/yyyy").format(ordine.getDataConsegna()) : "-" %></strong></p>
        </div>

        <div class="admin-grid dettaglio-prodotti-grid">
            <h3 class="admin-box-title dettaglio-sezione-titolo">Articoli Acquistati</h3>

            <%
                for (ProdottoBean prodotto : prodottiOrdinati) {
                    int qta = prodotto.getDisponibilita();
                    double prezzoUnitario = prodotto.getPrezzo();
                    double totaleArticolo = prezzoUnitario * qta;
            %>
            <div class="admin-box dettaglio-prodotto-row">
                <div class="dettaglio-prodotto-left">
                    <h4 class="admin-box-title dettaglio-prodotto-titolo"><%= prodotto.getTitolo() %></h4>
                    <p class="admin-box-text dettaglio-prodotto-sub">Autore: <%= prodotto.getAutore() %> | ISBN: <%= prodotto.getIsbn() %></p>
                </div>
                <div class="dettaglio-prodotto-right">
                    <p class="admin-box-text dettaglio-riga-testo">Quantit&agrave;: <strong><%= qta %></strong></p>
                    <p class="admin-box-title dettaglio-prodotto-prezzo">
                        &euro; <%= String.format("%.2f", totaleArticolo) %> <span class="dettaglio-prezzo-unitario">(&euro; <%= String.format("%.2f", prezzoUnitario) %> cad.)</span>
                    </p>
                </div>
            </div>
            <%
                }
            %>
        </div>

        <div class="admin-box dettaglio-totale-box">
            <h3 class="admin-box-title dettaglio-totale-titolo">Totale Pagato (IVA inclusa)</h3>
            <h2 class="profile-title dettaglio-totale-cifra">&euro; <%= String.format("%.2f", ordine.getCosto()) %></h2>
        </div>
        <%
        } else {
        %>
        <div class="admin-box ordini-vuoto-box">
            <p class="admin-box-text ordini-vuoto-testo">Impossibile caricare i dettagli dell'ordine richiesto.</p>
        </div>
        <%
            }
        %>

        <div class="admin-footer-back">
            <a href="<%= request.getContextPath() %>/OrdiniUtenteServlet">
                Torna all'elenco ordini
            </a>
        </div>
    </div>
</main>

<jsp:include page="footer.jsp" />
<jsp:include page="bottone.jsp" />
<script src="${pageContext.request.contextPath}/javascripts/bottone.js"></script>

</body>
</html>