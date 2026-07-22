<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.ordine.OrdineBean" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>I Miei Ordini - Readly</title>
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Cabin:wght@700&family=Segoe+UI:wght@400;600;700&display=swap" />
  <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/stylesheets/auth.css">
  <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/stylesheets/areaPersonale.css?v=8">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/bottone.css">
</head>
<body>

<jsp:include page="header.jsp" />

<main class="admin-main">
  <div class="admin-card">
    <div class="sezione-introduzione">
      <h1 class="profile-title">I Miei Ordini</h1>
      <p class="profile-subtitle">Visualizza lo storico e lo stato degli acquisti effettuati su Readly.</p>
    </div>

    <%
      List<OrdineBean> listaOrdini = (List<OrdineBean>) request.getAttribute("listaOrdini");
      if (listaOrdini != null && !listaOrdini.isEmpty()) {
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    %>
    <div class="admin-grid ordini-grid-verticale">
      <%
        for (OrdineBean ordine : listaOrdini) {
          String dataFormattata = (ordine.getDataOrdine() != null) ? sdf.format(ordine.getDataOrdine()) : "";
      %>
      <div class="admin-box ordine-card-row">
        <div class="ordine-info-left">
          <h3 class="admin-box-title ordine-title-margin">Ordine #<%= ordine.getNumeroOrdine() %></h3>
          <p class="admin-box-text ordine-text-reset">
            Data: <strong><%= dataFormattata %></strong>
          </p>
          <p class="admin-box-text ordine-text-reset">
            Spedito a: <span><%= ordine.getIndirizzo() %></span>
          </p>
        </div>

        <div class="ordine-dettagli-right">
          <div>
            <p class="admin-box-title ordine-prezzo-testo">
              &euro; <%= String.format("%.2f", ordine.getCosto()) %>
            </p>
            <span class="ordine-stato-badge">
              <%= ordine.getStatoOrdine() %>
            </span>
          </div>
          <a href="<%= request.getContextPath() %>/OrdiniUtenteServlet?idOrdine=<%= ordine.getNumeroOrdine() %>" class="btn-admin btn-dettagli-ordine">
            Vedi Dettagli
          </a>
        </div>
      </div>
      <%
        }
      %>
    </div>
    <%
    } else {
    %>
    <div class="admin-box ordini-vuoto-box">
      <p class="admin-box-text ordini-vuoto-testo">Non hai ancora effettuato nessun ordine.</p>
    </div>
    <%
      }
    %>

    <div class="admin-footer-back">
      <a href="<%= request.getContextPath() %>/AreaPersonaleServlet">
        Torna al mio profilo utente
      </a>
    </div>
  </div>
</main>

<jsp:include page="footer.jsp" />
<jsp:include page="bottone.jsp" />
<script src="${pageContext.request.contextPath}/javascripts/bottone.js"></script>

</body>
</html>