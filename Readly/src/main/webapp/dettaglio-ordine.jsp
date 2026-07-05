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
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/stylesheets/areaPersonale.css">
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

        <div class="admin-box" style="display: block; text-align: left; padding: 25px; min-height: auto; margin-bottom: 30px; width:100%;">
            <p class="admin-box-text" style="margin: 5px 0;">Corriere assegnato: <strong><%= ordine.getCorriere() %></strong></p>
            <p class="admin-box-text" style="margin: 5px 0;">Indirizzo di consegna: <strong><%= ordine.getIndirizzo() %></strong></p>
            <p class="admin-box-text" style="margin: 5px 0;">Data consegna stimata/effettiva: <strong><%= (ordine.getDataConsegna() != null) ? new SimpleDateFormat("dd/MM/yyyy").format(ordine.getDataConsegna()) : "-" %></strong></p>
        </div>

        <div class="admin-grid" style="flex-direction: column; gap: 15px; margin: 2% 0;">
            <h3 class="admin-box-title" style="text-align: left; width: 100%; margin-bottom: 5px;">Articoli Acquistati</h3>

            <%
                for (ProdottoBean prodotto : prodottiOrdinati) {
                    int qta = prodotto.getDisponibilita();
                    double prezzoUnitario = prodotto.getPrezzo();
                    double totaleArticolo = prezzoUnitario * qta;
            %>
            <div class="admin-box" style="flex-direction: row; justify-content: space-between; align-items: center; min-height: auto; padding: 15px 20px; background-color: #ffffff; width: 100%;">
                <div style="text-align: left;">
                    <h4 class="admin-box-title" style="font-size: 1.1rem; margin: 0; text-transform: none; color: var(--text-primary);"><%= prodotto.getTitolo() %></h4>
                    <p class="admin-box-text" style="margin: 3px 0 0 0; font-size: 0.9rem;">Autore: <%= prodotto.getAutore() %> | ISBN: <%= prodotto.getIsbn() %></p>
                </div>
                <div style="text-align: right;">
                    <p class="admin-box-text" style="margin: 0;">Quantit&agrave;: <strong><%= qta %></strong></p>
                    <p class="admin-box-title" style="font-size: 1.05rem; margin: 3px 0 0 0; color: #677351;">
                        &euro; <%= String.format("%.2f", totaleArticolo) %> <span style="font-size: 0.8rem; font-weight: normal; color: var(--text-secondary);">(&euro; <%= String.format("%.2f", prezzoUnitario) %> cad.)</span>
                    </p>
                </div>
            </div>
            <%
                }
            %>
        </div>

        <div class="admin-box" style="flex-direction: row; justify-content: space-between; align-items: center; min-height: auto; padding: 20px; background-color: #F6F0D7; border-color: #89986D; width: 100%; margin-top: 10px;">
            <h3 class="admin-box-title" style="margin: 0; color: #677351;">Totale Pagato (IVA inclusa)</h3>
            <h2 class="profile-title" style="margin: 0; font-size: 2rem; color: #677351;">&euro; <%= String.format("%.2f", ordine.getCosto()) %></h2>
        </div>
        <%
        } else {
        %>
        <div class="admin-box" style="padding: 40px; min-height: auto; margin: 20px 0;">
            <p class="admin-box-text" style="font-size: 1.1rem; margin: 0;">Impossibile caricare i dettagli dell'ordine richiesto.</p>
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

</body>
</html>