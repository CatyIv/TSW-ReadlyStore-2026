<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.prodotto.ProdottoBean" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Gestione Prodotto - Area Admin</title>
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Cabin:wght@700&family=Segoe+UI:wght@400;600;700&display=swap" />
  <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/stylesheets/admin.css">
  <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/stylesheets/areaPersonale.css">
</head>
<body>

<jsp:include page="../header.jsp" />

<main class="admin-main">
  <div class="admin-card">
    <%
      ProdottoBean libro = (ProdottoBean) request.getAttribute("libroEdizione");
      List<String> backupImmagini = (List<String>) request.getAttribute("backupImmagini");
      String errorMessage = (String) request.getAttribute("errorMessage");

      String forceAction = (String) request.getAttribute("forceAction");
      boolean isEdit = (libro != null) && !"insert".equals(forceAction);

      long cacheBuster = System.currentTimeMillis();
    %>

    <div class="sezione-introduzione">
      <h1 class="profile-title"><%= isEdit ? "MODIFICA PRODOTTO" : "AGGIUNGI NUOVO PRODOTTO" %></h1>
      <p class="profile-subtitle">Compila i campi e seleziona una copertina dal tuo PC per gestire il volume.</p>
    </div>

    <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
    <div class="global-error">
      <%= errorMessage %>
    </div>
    <% } %>

    <div class="admin-lista-verticale">
      <div class="admin-box">
        <form action="<%= request.getContextPath() %>/admin/GestioneProdottiServlet" method="POST" enctype="multipart/form-data" class="admin-form-flusso">
          <input type="hidden" name="formAction" value="<%= isEdit ? "update" : "insert" %>">

          <div class="form-group">
            <label>ISBN <%= isEdit ? "(Non modificabile)" : "" %>:</label>
            <input type="text" name="isbn" value="<%= libro != null ? libro.getIsbn() : "" %>" <%= isEdit ? "readonly" : "" %> required maxlength="13">
          </div>

          <div class="form-group">
            <label>Titolo del Libro:</label>
            <input type="text" name="titolo" value="<%= libro != null ? libro.getTitolo() : "" %>" required>
          </div>

          <div class="form-group">
            <label>Autore:</label>
            <input type="text" name="autore" value="<%= libro != null ? libro.getAutore() : "" %>" required>
          </div>

          <div class="form-group">
            <label>Prezzo (€):</label>
            <input type="number" name="prezzo" step="0.01" value="<%= libro != null ? libro.getPrezzo() : "0.00" %>" required>
          </div>

          <div class="form-group">
            <label>Scorte in Magazzino (Copie):</label>
            <input type="number" name="disponibilita" value="<%= libro != null ? libro.getDisponibilita() : "0" %>" required min="0">
          </div>

          <div class="form-group">
            <label>Categoria:</label>
            <input type="text" name="categoria" value="<%= libro != null ? libro.getCategoria() : "" %>" required>
          </div>

          <div class="form-group">
            <label>Descrizione:</label>
            <textarea name="descrizione" rows="6" required><%= libro != null ? libro.getDescrizione() : "" %></textarea>
          </div>

          <div class="form-group">
            <label>Carica Copertina (File dal tuo PC):</label>
            <input type="file" name="fotoCopertina" accept="image/*" class="input-file-admin">
          </div>

          <% if (isEdit) { %>
          <div class="form-group admin-sezione-anteprima">
            <label class="label-anteprima">Copertina Attuale in Uso</label>
            <div class="admin-wrapper-copertina">
              <img src="<%= request.getContextPath() %>/img/copertine/<%= libro.getIsbn() %>.jpg?v=<%= cacheBuster %>"
                   alt="Copertina Attuale"
                   class="admin-img-principale"
                   onerror="this.src='<%= request.getContextPath() %>/img/copertine/default_book.png';">
            </div>
          </div>

          <div class="form-group admin-sezione-storico">
            <label class="label-anteprima">Ripristina una Copertina Precedente</label>

            <% if (backupImmagini != null && !backupImmagini.isEmpty()) { %>
            <div class="admin-griglia-backup">
              <% for (String nomeFileBackup : backupImmagini) { %>
              <form action="<%= request.getContextPath() %>/admin/GestioneProdottiServlet" method="POST" class="admin-form-miniatura">
                <input type="hidden" name="formAction" value="restoreBackup">
                <input type="hidden" name="isbn" value="<%= libro.getIsbn() %>">
                <input type="hidden" name="nomeFileBackup" value="<%= nomeFileBackup %>">

                <button type="submit" class="admin-btn-miniatura" title="Clicca per ripristinare questa versione">
                  <img src="<%= request.getContextPath() %>/img/copertine/backup/<%= nomeFileBackup %>?v=<%= cacheBuster %>"
                       alt="Backup"
                       class="admin-img-backup"
                       onerror="this.src='<%= request.getContextPath() %>/img/copertine/default_book.png';">
                </button>
              </form>
              <% } %>
            </div>
            <% } else { %>
            <p class="admin-box-text text-storico-vuoto">Nessuna copertina precedente salvata nell'archivio storico.</p>
            <% } %>
          </div>
          <% } %>

          <div class="admin-blocco-pulsante-salva">
            <button type="submit" class="btn-auth btn-salva-flusso"><%= isEdit ? "Salva Modifiche e Immagine" : "Inserisci nel Catalogo" %></button>
          </div>
        </form>
      </div>
    </div>

    <div class="admin-footer-back">
      <a href="<%= request.getContextPath() %>/admin/GestioneProdottiServlet">Annulla e Torna al Catalogo</a>
    </div>
  </div>
</main>

<jsp:include page="../footer.jsp" />

</body>
</html>