<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.ordine.OrdineBean" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Monitoraggio Ordini - Area Admin</title>
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Cabin:wght@700&family=Segoe+UI:wght@400;600;700&display=swap" />
  <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/stylesheets/admin.css">
  <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/stylesheets/areaPersonale.css">
</head>
<body>

<jsp:include page="../header.jsp" />

<main class="admin-main">
  <div class="admin-card">
    <div class="sezione-introduzione">
      <h1 class="profile-title">Pannello Controllo Ordini</h1>
      <p class="profile-subtitle">Visualizza e modifica lo stato di tutti gli acquisti del portale.</p>
    </div>

    <div class="admin-grid">
      <div class="admin-box">
        <h3 class="admin-box-title">Filtra per Cliente</h3>
        <form action="<%= request.getContextPath() %>/admin/GestioneOrdiniServlet" method="GET">
          <input type="hidden" name="filterType" value="cliente">
          <div class="form-group">
            <input type="email" name="emailCliente" placeholder="email@esempio.com" required>
          </div>
          <button type="submit" class="btn-auth" style="display: inline-block; width: auto; padding: 0.6rem 2rem;">Cerca</button>
        </form>
      </div>

      <div class="admin-box">
        <h3 class="admin-box-title">Filtra per Date</h3>
        <form action="<%= request.getContextPath() %>/admin/GestioneOrdiniServlet" method="GET">
          <input type="hidden" name="filterType" value="date">
          <div class="form-group" style="margin-bottom: 0.5rem;">
            <input type="date" name="dataInizio" required>
          </div>
          <div class="form-group">
            <input type="date" name="dataFine" required>
          </div>
          <button type="submit" class="btn-auth" style="display: inline-block; width: auto; padding: 0.6rem 2rem;">Filtra Range</button>
        </form>
      </div>
    </div>

    <div class="back-profile-link" style="text-align: center; margin-bottom: 2rem;">
      <a href="<%= request.getContextPath() %>/admin/GestioneOrdiniServlet" class="btn-auth" style="display: inline-block; width: auto; padding: 0.75rem 2rem; text-decoration: none;">Mostra Tutti gli Ordini</a>
    </div>

    <div class="admin-lista-verticale">
      <%
        List<OrdineBean> tuttiGliOrdini = (List<OrdineBean>) request.getAttribute("tuttiGliOrdini");
        if (tuttiGliOrdini != null && !tuttiGliOrdini.isEmpty()) {
          SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
          for (OrdineBean ordine : tuttiGliOrdini) {
            String dataFormattata = (ordine.getDataOrdine() != null) ? sdf.format(ordine.getDataOrdine()) : "";
      %>
      <div class="admin-box" style="display: flex; justify-content: space-between; align-items: flex-start; gap: 20px;">
        <div style="display: flex; flex-direction: column; align-items: flex-start; gap: 15px; flex-grow: 1;">
          <div>
            <h3 class="admin-box-title">Ordine #<%= ordine.getNumeroOrdine() %></h3>
            <p class="admin-box-text">Utente: <strong><%= ordine.getIdUtente() %></strong></p>
            <p class="admin-box-text">Data: <span><%= dataFormattata %></span></p>
            <p class="admin-box-text">Importo: <strong>&euro; <%= String.format("%.2f", ordine.getCosto()) %></strong></p>
          </div>

          <div>
            <a href="<%= request.getContextPath() %>/admin/GestioneOrdiniServlet?action=dettaglio&numeroOrdine=<%= ordine.getNumeroOrdine() %>"
               class="btn-admin" style="display: inline-block; text-decoration: none; padding: 0.5rem 1.5rem;">Vedi Dettagli</a>
          </div>
        </div>

        <div style="display: flex; flex-direction: column; min-width: 200px; max-width: 240px; align-self: center;">
          <form action="<%= request.getContextPath() %>/admin/GestioneOrdiniServlet" method="POST" style="display: flex; flex-direction: column; gap: 10px; width: 100%; align-items: flex-start;">
            <input type="hidden" name="numeroOrdine" value="<%= ordine.getNumeroOrdine() %>">

            <div class="form-group" style="margin-bottom: 0; width: 100%; display: flex; flex-direction: column; align-items: flex-start;">
              <label class="admin-box-text" style="margin-bottom: 5px; text-align: left; width: 100%;">Stato:</label>
              <select name="nuovoStato" style="cursor: pointer; padding: 0.5rem 1rem; width: 100%; border-radius: 50px; font-family: inherit; -webkit-appearance: none; -moz-appearance: none; appearance: none; background-image: url('data:image/svg+xml;utf8,<svg xmlns=%22http://www.w3.org/2000/svg%22 width=%2224%22 height=%2224%22 viewBox=%220 0 24 24%22><path fill=%22%23677351%22 d=%22M7 10l5 5 5-5z%22/></svg>'); background-repeat: no-repeat; background-position: right 12px center; background-size: 16px;">
                <option value="In lavorazione" <%= "In lavorazione".equals(ordine.getStatoOrdine()) ? "selected" : "" %>>In lavorazione</option>
                <option value="Spedito" <%= "Spedito".equals(ordine.getStatoOrdine()) ? "selected" : "" %>>Spedito</option>
                <option value="In Consegna" <%= "In Consegna".equals(ordine.getStatoOrdine()) ? "selected" : "" %>>In Consegna</option>
                <option value="Consegnato" <%= "Consegnato".equals(ordine.getStatoOrdine()) ? "selected" : "" %>>Consegnato</option>
                <option value="Annullato" <%= "Annullato".equals(ordine.getStatoOrdine()) ? "selected" : "" %>>Annullato</option>
              </select>
            </div>
            <button type="submit" class="btn-auth" style="margin-top: 0; padding: 0.5rem; font-size: 1rem; width: 100%;">Aggiorna Stato</button>
          </form>
        </div>
      </div>
      <%
        }
      } else {
      %>
      <div class="admin-box">
        <p class="admin-box-text">Nessun ordine trovato con i criteri di ricerca impostati.</p>
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