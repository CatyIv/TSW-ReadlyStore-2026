<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.utente.UtenteBean" %>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Monitoraggio Utenti - Area Admin</title>
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Cabin:wght@700&family=Segoe+UI:wght@400;600;700&display=swap" />
  <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/stylesheets/auth.css">
  <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/stylesheets/areaPersonale.css">
</head>
<body>

<jsp:include page="../header.jsp" />

<main class="admin-main">
  <div class="admin-card">
    <div class="sezione-introduzione">
      <h1 class="profile-title">Monitoraggio Utenti Registrati</h1>
      <p class="profile-subtitle">Elenco complessivo dei clienti e degli amministratori della piattaforma Readly.</p>
    </div>

    <div class="admin-lista-verticale">
      <%
        List<UtenteBean> listaUtenti = (List<UtenteBean>) request.getAttribute("listaUtenti");
        if (listaUtenti != null && !listaUtenti.isEmpty()) {
          for (UtenteBean u : listaUtenti) {
      %>
      <div class="admin-box">
        <div>
          <h3 class="admin-box-title"><%= u.getCognome() %> <%= u.getNome() %></h3>
          <p class="admin-box-text">Email: <strong><%= u.getEmail() %></strong></p>
          <p class="admin-box-text">Telefono: <span><%= u.getTelefono() != null ? u.getTelefono() : "-" %></span></p>
          <p class="admin-box-text">Ruolo Attuale: <strong><%= u.isAdmin() ? "Amministratore" : "Cliente" %></strong></p>
        </div>

        <div>
          <a href="<%= request.getContextPath() %>/admin/GestioneUtentiServlet?action=cambiaRuolo&emailUtente=<%= u.getEmail() %>"
             class="btn-admin"
             onclick="return confirm('Vuoi davvero modificare il ruolo di questo utente?')">
            <%= u.isAdmin() ? "Rendi Cliente" : "Rendi Admin" %>
          </a>
        </div>
      </div>
      <%
        }
      } else {
      %>
      <div class="admin-box">
        <p class="admin-box-text">Nessun utente registrato nel database.</p>
      </div>
      <%
        }
      %>
    </div>

    <div class="admin-footer-back">
      <a href="<%= request.getContextPath() %>/admin/DashboardServlet">
        Torna alla Dashboard Admin
      </a>
    </div>
  </div>
</main>

<jsp:include page="../footer.jsp" />

</body>
</html>