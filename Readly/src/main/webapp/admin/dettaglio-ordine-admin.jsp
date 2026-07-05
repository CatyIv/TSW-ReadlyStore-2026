<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.ordine.OrdineBean" %>
<%@ page import="model.prodotto.ProdottoBean" %>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Dettaglio Ordine #<%= ((OrdineBean)request.getAttribute("ordine")).getNumeroOrdine() %> - Admin</title>
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Cabin:wght@700&family=Segoe+UI:wght@400;600;700&display=swap" />
  <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/stylesheets/admin.css">
  <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/stylesheets/areaPersonale.css">
</head>
<body>

<jsp:include page="../header.jsp" />

<main class="admin-main">
  <div class="admin-card">
    <%
      OrdineBean ordine = (OrdineBean) request.getAttribute("ordine");
      List<ProdottoBean> prodottiOrdinati = (List<ProdottoBean>) request.getAttribute("prodottiOrdinati");
      if (ordine != null) {
    %>
    <div class="sezione-introduzione">
      <h1 class="profile-title">Dettaglio Ordine #<%= ordine.getNumeroOrdine() %></h1>
      <p class="profile-subtitle">Riepilogo dei prodotti acquistati dall'utente <strong><%= ordine.getIdUtente() %></strong></p>
    </div>

    <div class="admin-lista-verticale">
      <%
        if (prodottiOrdinati != null && !prodottiOrdinati.isEmpty()) {
          for (ProdottoBean prodotto : prodottiOrdinati) {
      %>
      <div class="admin-box">
        <div>
          <h3 class="admin-box-title"><%= prodotto.getTitolo() %></h3>
          <p class="admin-box-text">Autore: <strong><%= prodotto.getAutore() %></strong></p>
          <p class="admin-box-text">ISBN: <span><%= prodotto.getIsbn() %></span></p>
          <p class="admin-box-text">Quantità ordinata: <strong><%= prodotto.getDisponibilita() %>x</strong></p>
        </div>
        <div>
          <p class="admin-box-title">&euro; <%= String.format("%.2f", prodotto.getPrezzo()) %></p>
          <p class="admin-box-text">IVA applicata: <%= prodotto.getIva() %>%</p>
        </div>
      </div>
      <%
          }
        }
      %>

      <div class="admin-box">
        <div>
          <h3 class="admin-box-title">Informazioni di Spedizione</h3>
          <p class="admin-box-text">Indirizzo: <span><%= ordine.getIndirizzo() %></span></p>
          <p class="admin-box-text">Corriere: <span><%= ordine.getCorriere() %></span></p>
          <p class="admin-box-text">Stato Spedizione: <strong><%= ordine.getStatoOrdine() %></strong></p>
        </div>
        <div>
          <h3 class="admin-box-title">Totale Transazione</h3>
          <h2 class="profile-title">&euro; <%= String.format("%.2f", ordine.getCosto()) %></h2>
        </div>
      </div>
    </div>
    <%
    } else {
    %>
    <div class="admin-box">
      <p class="admin-box-text">Impossibile recuperare le informazioni di questo ordine.</p>
    </div>
    <%
      }
    %>

    <div class="admin-footer-back">
      <a href="<%= request.getContextPath() %>/admin/GestioneOrdiniServlet">
        Torna all'Elenco Ordini
      </a>
    </div>
  </div>
</main>

<jsp:include page="../footer.jsp" />

</body>
</html>