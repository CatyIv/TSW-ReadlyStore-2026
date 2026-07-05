<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.prodotto.ProdottoBean" %>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Gestione Catalogo Libri - Area Admin</title>
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Cabin:wght@700&family=Segoe+UI:wght@400;600;700&display=swap" />
  <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/stylesheets/auth.css">
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

    <div class="back-profile-link">
      <a href="<%= request.getContextPath() %>/admin/GestioneProdottiServlet?action=new" class="btn-admin">+ Aggiungi Nuovo Libro</a>    </div>

    <div class="admin-lista-verticale">
      <%
        List<ProdottoBean> prodotti = (List<ProdottoBean>) request.getAttribute("prodotti");
        if (prodotti != null && !prodotti.isEmpty()) {
          for (ProdottoBean p : prodotti) {
      %>
      <div class="admin-box">
        <div>
          <h3 class="admin-box-title"><%= p.getTitolo() %></h3>
          <p class="admin-box-text">Autore: <strong><%= p.getAutore() %></strong></p>
          <p class="admin-box-text">ISBN: <span><%= p.getIsbn() %></span></p>
          <p class="admin-box-text">Disponibilità: <strong><%= p.getDisponibilita() %> copie</strong></p>
          <p class="admin-box-text">Categoria: <span><%= p.getCategoria() %></span></p>
        </div>

        <div>
          <h2 class="admin-box-title">&euro; <%= String.format("%.2f", p.getPrezzo()) %></h2>

          <div class="back-profile-link">
            <a href="<%= request.getContextPath() %>/admin/GestioneProdottiServlet?action=edit&isbn=<%= p.getIsbn() %>" class="btn-admin">Modifica</a>
          </div>

          <div class="back-profile-link">
            <a href="<%= request.getContextPath() %>/admin/GestioneProdottiServlet?action=delete&isbn=<%= p.getIsbn() %>"
               class="btn-admin"
               onclick="return confirm('Sei sicuro di voler eliminare definitivamente questo libro dal catalogo?')">
              Elimina
            </a>
          </div>
        </div>
      </div>
      <%
        }
      } else {
      %>
      <div class="admin-box">
        <p class="admin-box-text">Nessun libro presente nel catalogo.</p>
      </div>
      <%
        }
      %>
    </div>

    <div class="admin-footer-back">
      <a href="<%= request.getContextPath() %>/admin/DashboardServlet">Torna alla Dashboard Admin</a>
    </div>
  </div>
</main>

<jsp:include page="../footer.jsp" />

</body>
</html>