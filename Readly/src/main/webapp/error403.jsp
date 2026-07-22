<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Errore 403 - Readly</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/stylesheets/auth.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/stylesheets/error.css?v=2">
</head>
<body>

<jsp:include page="header.jsp" />

<main class="contenitore-principale-errore">
    <h1>Errore 403</h1>

    <div class="errore-box-layout">
        <div class="errore-testo-box">
            <h2>Accesso Riservato!</h2>
            <p>Torna al <a href="<%= request.getContextPath() %>/CatalogoServlet">Catalogo</a> per esplorare i nostri libri.</p>
        </div>

        <div class="errore-immagine-box">
            <img src="<%= request.getContextPath() %>/img/error403.png" alt="Errore 403 Mascotte" class="mascotte-errore-img">
        </div>
    </div>
</main>

<jsp:include page="footer.jsp" />

</body>
</html>