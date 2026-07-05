<%@ page import="model.utente.UtenteBean" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Area Personale - Readly</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Cabin:wght@700&family=Segoe+UI:wght@400;600;700&display=swap" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20,400,0,0" />
    <link rel="stylesheet" type="text/css" href="./stylesheets/auth.css?v=5">
    <link rel="stylesheet" type="text/css" href="./stylesheets/areaPersonale.css?v=5">
</head>
<body>

<jsp:include page="header.jsp" />

<main class="admin-main">
    <div class="admin-card">
        <h1 class="profile-title">Il Mio Profilo</h1>
        <p class="profile-subtitle">Benvenuto nella tua area privata. Gestisci le tue informazioni e i tuoi acquisti.</p>

        <%
            UtenteBean utente = (UtenteBean) session.getAttribute("utente");
            String action = request.getParameter("action");

            if (utente != null && utente.isAdmin() && (action == null || !action.equals("edit"))) {
        %>
        <div class="admin-alert-box">
            <p class="admin-alert-text">Account Amministratore Rilevato</p>
            <a href="<%= request.getContextPath() %>/admin/DashboardServlet" class="btn-admin-alert">
                Accedi al Pannello Admin
            </a>
        </div>
        <%
            }

            if (action != null && action.equals("edit")) {
        %>
        <form action="<%= request.getContextPath() %>/ModificaUtenteServlet" method="POST" class="profile-form">

            <%
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null) {
            %>
            <div class="admin-alert-box" style="border-color: #c94c4c; margin-bottom: 20px;">
                <p class="admin-alert-text" style="color: #c94c4c; margin-bottom: 10px;">Attenzione</p>
                <p class="admin-box-text" style="color: #c94c4c; margin: 0;"><%= errorMessage %></p>
            </div>
            <%
                }
            %>

            <div class="form-group">
                <label for="nome">Nome</label>
                <input type="text" id="nome" name="nome" value="<%= utente != null ? utente.getNome() : "" %>" required>
            </div>

            <div class="form-group">
                <label for="cognome">Cognome</label>
                <input type="text" id="cognome" name="cognome" value="<%= utente != null ? utente.getCognome() : "" %>" required>
            </div>

            <div class="form-group">
                <label for="email">Indirizzo Email (Non modificabile)</label>
                <input type="email" id="email" name="email" value="<%= utente != null ? utente.getEmail() : "" %>" readonly class="input-readonly">
            </div>

            <div class="form-group">
                <label for="telefono">Numero di Telefono</label>
                <input type="tel" id="telefono" name="telefono" value="<%= utente != null ? utente.getTelefono() : "" %>" required maxlength="13">
            </div>

            <button type="submit" class="btn-auth">Salva Modifiche</button>

            <div class="back-profile-link">
                <a href="<%= request.getContextPath() %>/AreaPersonaleServlet">Annulla e torna indietro</a>
            </div>
        </form>
        <%
        } else {
        %>
        <div class="admin-grid">
            <div class="admin-box">
                <span class="material-symbols-outlined admin-icon">badge</span>
                <h3 class="admin-box-title">I Miei Dati</h3>
                <div class="user-info-summary">
                    <p><strong><%= utente != null ? utente.getNome() + " " + utente.getCognome() : "" %></strong></p>
                    <p><%= utente != null ? utente.getEmail() : "" %></p>
                    <p><%= utente != null ? utente.getTelefono() : "" %></p>
                </div>
                <a href="<%= request.getContextPath() %>/AreaPersonaleServlet?action=edit" class="btn-auth btn-admin">Modifica</a>
            </div>

            <div class="admin-box">
                <span class="material-symbols-outlined admin-icon">local_shipping</span>
                <h3 class="admin-box-title">I Miei Ordini</h3>
                <p class="admin-box-text">Visualizza lo storico degli acquisti e traccia le deine spedizioni</p>
                <a href="<%= request.getContextPath() %>/OrdiniUtenteServlet" class="btn-auth btn-admin">Visualizza</a>
            </div>

            <div class="admin-box">
                <span class="material-symbols-outlined admin-icon">bookmark</span>
                <h3 class="admin-box-title">I Miei Preferiti</h3>
                <p class="admin-box-text">Controlla i libri che hai salvato nella tua lista dei desideri</p>
                <a href="<%= request.getContextPath() %>/WishlistServlet" class="btn-auth btn-admin">Vedi Lista</a>
            </div>
        </div>
        <%
            }
        %>

        <div class="logout-container">
            <a href="<%= request.getContextPath() %>/LogoutServlet" class="btn-logout-profilo">
                Effettua il Logout
            </a>
        </div>
    </div>
</main>

<jsp:include page="footer.jsp" />

</body>
</html>