<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contatti - Readly</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Cabin:wght@700&family=Segoe+UI:wght@400;600;700&display=swap" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20,400,0,0" />
    <link rel="stylesheet" type="text/css" href="stylesheets/contatti.css?v=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/bottone.css">
</head>
<body>

<jsp:include page="header.jsp" />

<div class="contenitore-contatti">

    <div class="sezione-introduzione">
        <h1 class="titolo-pagina">Contatti</h1>
        <p class="sottotitolo-pagina">Hai domande sui nostri libri o sul tuo ordine? Il team di Readly è a tua disposizione.</p>
    </div>

    <div class="griglia-valori">
        <div class="card-valore">
            <span class="material-symbols-outlined icona-valore">pin_drop</span>
            <h3>Indirizzo</h3>
            <p>Readly S.r.l.<br>Casella Postale 189<br>20121 Milano (MI)</p>
        </div>

        <div class="card-valore">
            <span class="material-symbols-outlined icona-valore">mail</span>
            <h3>Ufficio & Web</h3>
            <p>Info: <strong>info@readly.it</strong><br>Webmaster: <strong>webmaster@readly.it</strong></p>
        </div>

        <div class="card-valore">
            <span class="material-symbols-outlined icona-valore">schedule</span>
            <h3>Orari & Telefono</h3>
            <p>Lun-Ven 9:00 - 16:00<br>Tel: <strong>+39 345 678 9822</strong></p>
        </div>
    </div>
</div>
<jsp:include page="footer.jsp" />
<jsp:include page="bottone.jsp" />
<script src="${pageContext.request.contextPath}/javascripts/bottone.js"></script>


</body>
</html>