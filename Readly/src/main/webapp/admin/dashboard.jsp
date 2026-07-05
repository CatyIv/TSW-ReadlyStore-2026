<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Pannello Amministrazione - Readly</title>
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Cabin:wght@700&family=Segoe+UI:wght@400;600;700&display=swap" />
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20,400,0,0" />
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/stylesheets/auth.css?v=6">
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/stylesheets/areaPersonale.css?v=6">
</head>
<body>

<jsp:include page="../header.jsp" />

<main class="admin-main">
  <div class="admin-card">
    <div class="sezione-introduzione">
      <h1 class="profile-title">Pannello di Controllo</h1>
      <p class="profile-subtitle">Benvenuto Amministratore. Qui puoi gestire l'intero store di Readly.</p>
    </div>

    <div class="admin-grid">
      <div class="admin-box">
        <span class="material-symbols-outlined admin-icon">menu_book</span>
        <h3 class="admin-box-title">Prodotti</h3>
        <p class="admin-box-text">Aggiungi, modifica o elimina libri dal catalogo</p>
        <a href="${pageContext.request.contextPath}/admin/GestioneProdottiServlet" class="btn-auth btn-admin">Gestisci</a>
      </div>

      <div class="admin-box">
        <span class="material-symbols-outlined admin-icon">shopping_bag</span>
        <h3 class="admin-box-title">Ordini</h3>
        <p class="admin-box-text">Visualizza e modifica lo stato di tutti gli ordini</p>
        <a href="${pageContext.request.contextPath}/admin/GestioneOrdiniServlet" class="btn-auth btn-admin">Gestisci</a>
      </div>

      <div class="admin-box">
        <span class="material-symbols-outlined admin-icon">group</span>
        <h3 class="admin-box-title">Utenti</h3>
        <p class="admin-box-text">Monitora i clienti registrati e i relativi permessi</p>
        <a href="${pageContext.request.contextPath}/admin/GestioneUtentiServlet" class="btn-auth btn-admin">Gestisci</a>
      </div>
    </div>

    <div class="admin-footer-back">
      <a href="${pageContext.request.contextPath}/AreaPersonaleServlet">
        Torna al mio profilo utente
      </a>
    </div>
  </div>
</main>

<jsp:include page="../footer.jsp" />

</body>
</html>