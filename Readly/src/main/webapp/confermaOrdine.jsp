<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <title>Ordine Confermato - Readly</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20,400,0,0" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/checkout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/bottone.css">
</head>
<body class="page-checkout">

<jsp:include page="header.jsp" />

<main class="main-ordine-confermato">

    <div class="box-ordine-confermato">

        <div class="conferma-testo-col">
            <h2>
                Grazie per il tuo acquisto!
            </h2>
            <p>
                Il tuo ordine è stato ricevuto con successo ed è in fase di elaborazione.
                Puoi monitorare lo stato della spedizione direttamente dalla tua area personale.
            </p>

            <div class="conferma-azioni-box">
                <a href="${pageContext.request.contextPath}/FatturaServlet?numero_ordine=${not empty param.numero_ordine ? param.numero_ordine : sessionScope.ultimoNumeroOrdine}" class="confirm-order-btn btn-fattura-pdf">
                    Scarica Fattura PDF
                </a>

                <a href="${pageContext.request.contextPath}/CatalogoServlet" style="color: #677351; font-weight: bold; text-decoration: none; font-size: 18px; margin-top: 10px;">
                    Torna al <span style="text-decoration: underline;">Catalogo</span> per esplorare altri libri.
                </a>
            </div>
        </div>

        <div style="flex: 1 !important; display: flex !important; justify-content: center !important; align-items: center !important;">
            <img src="img/confermaOrdine.png" alt="Mascotte Ordine Confermato" style="width: 100% !important; max-width: 380px !important; height: auto !important; object-fit: contain !important;">
        </div>

    </div>
</main>

<jsp:include page="footer.jsp" />
<jsp:include page="bottone.jsp" />
<script src="${pageContext.request.contextPath}/javascripts/bottone.js"></script>


</body>
</html>