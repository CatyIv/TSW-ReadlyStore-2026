<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.prodotto.ProdottoBean" %>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Gestione Catalogo - Area Admin</title>
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Cabin:wght@700&family=Segoe+UI:wght@400;600;700&display=swap" />
  <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/stylesheets/admin.css">
  <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/stylesheets/areaPersonale.css">
</head>
<body>

<jsp:include page="../header.jsp" />

<main class="admin-main">
  <div class="admin-card">

    <div class="sezione-introduzione">
      <h1 class="profile-title">GESTIONE CATALOGO LIBRI</h1>
      <p class="profile-subtitle">Inserisci, modifica o rimuovi i volumi dal catalogo del portale.</p>
    </div>

    <div class="admin-contenitore-pulsante-nuovo">
      <a href="<%= request.getContextPath() %>/admin/GestioneProdottiServlet?action=new"
         class="btn-auth btn-admin-nuovo">
        + Aggiungi Nuovo Libro
      </a>
    </div>

    <div class="admin-lista-verticale">
      <%
        List<ProdottoBean> prodotti = (List<ProdottoBean>) request.getAttribute("prodotti");
        if (prodotti != null && !prodotti.isEmpty()) {
          for (ProdottoBean prodotto : prodotti) {
      %>
      <div class="admin-box admin-box-prodotto">

        <div class="admin-info-testo-prodotto">
          <h2 class="admin-box-title titolo-prodotto-lista"><%= prodotto.getTitolo() %></h2>
          <p class="admin-box-text">Autore: <strong class="evidenzia-testo-admin"><%= prodotto.getAutore() %></strong></p>
          <p class="admin-box-text">ISBN: <span class="subtesto-admin"><%= prodotto.getIsbn() %></span></p>
          <p class="admin-box-text">Disponibilità: <strong><%= prodotto.getDisponibilita() %> copie</strong></p>
          <p class="admin-box-text">Categoria: <span class="categoria-testo-admin"><%= prodotto.getCategoria() %></span></p>
        </div>

        <div class="admin-azioni-blocco-destro">
          <span class="admin-prezzo-testo">&euro; <%= String.format("%.2f", prodotto.getPrezzo()) %></span>

          <div class="admin-gruppo-tasti-azione">
            <a href="<%= request.getContextPath() %>/admin/GestioneProdottiServlet?action=edit&isbn=<%= prodotto.getIsbn() %>"
               class="btn-admin tasto-modifica-compatto">Modifica</a>

            <a href="<%= request.getContextPath() %>/admin/GestioneProdottiServlet?action=delete&isbn=<%= prodotto.getIsbn() %>"
               class="btn-admin tasto-elimina-compatto"
               onclick="return confirm('Sei sicuro di voler eliminare permanentemente questo libro dal catalogo?');">Elimina</a>
          </div>
        </div>

      </div>
      <%
        }
      } else {
      %>
      <div class="admin-box">
        <p class="admin-box-text testo-vuoto-allineato">Il catalogo dei prodotti è vuoto.</p>
      </div>
      <%
        }
      %>
    </div>

    <div class="admin-footer-back footer-spazio-top">
      <a href="<%= request.getContextPath() %>/admin/DashboardServlet">Torna alla Dashboard Admin</a>
    </div>
  </div>
</main>

<jsp:include page="../footer.jsp" />

</body>
</html>