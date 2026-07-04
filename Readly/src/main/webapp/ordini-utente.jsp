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
  <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/stylesheets/areaPersonale.css">
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
    <div class="admin-grid" style="flex-direction: column; gap: 20px;">
      <%
        for (OrdineBean ordine : listaOrdini) {
          String dataFormattata = (ordine.getDataOrdine() != null) ? sdf.format(ordine.getDataOrdine()) : "";
      %>
      <div class="admin-box" style="flex-direction: row; justify-content: space-between; align-items: center; min-height: auto; padding: 20px; width: 100%;">
        <div style="text-align: left;">
          <h3 class="admin-box-title" style="margin-bottom: 5px;">Ordine #<%= ordine.getNumeroOrdine() %></h3>
          <p class="admin-box-text" style="margin: 0;">
            Data: <strong><%= dataFormattata %></strong>
          </p>
          <p class="admin-box-text" style="margin: 0;">
            Spedito a: <span><%= ordine.getIndirizzo() %></span>
          </p>
        </div>

        <div style="text-align: right;">
          <p class="admin-box-title" style="margin-bottom: 5px; color: #677351;">
            &euro; <%= String.format("%.2f", ordine.getCosto()) %>
          </p>
          <span class="admin-box-text" style="display: inline-block; padding: 5px 15px; border-radius: 15px; background-color: #EADFBC; font-weight: bold; color: #677351;">
                                        <%= ordine.getStatoOrdine() %>
                                    </span>
        </div>
      </div>
      <%
        }
      %>
    </div>
    <%
    } else {
    %>
    <div class="admin-box" style="padding: 40px; min-height: auto; margin: 20px 0;">
      <p class="admin-box-text" style="font-size: 1.1rem; margin: 0;">Non hai ancora effettuato nessun ordine.</p>
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

</body>
</html>