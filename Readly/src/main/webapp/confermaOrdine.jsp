<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <title>Ordine Confermato - Readly</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20,400,0,0" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/stylesheets/checkout.css?v=11">
</head>
<body class="page-checkout">

<jsp:include page="header.jsp" />

<main style="display: flex; justify-content: center; align-items: center; min-height: 60vh; padding: 20px;">
    <div class="checkout-page" style="text-align: center; max-width: 600px; width: 100%; background-color: #FAF6E9; padding: 40px; border-radius: 8px; border: 1px solid #9BAE73;">

        <span class="material-symbols-outlined" style="font-size: 72px; color: #677351; margin-bottom: 15px;">check_circle</span>

        <h2 style="margin-bottom: 10px; color: #677351;">Grazie per il tuo acquisto!</h2>
        <p style="font-size: 18px; color: #677351; opacity: 0.9; margin-bottom: 30px;">
            Il tuo ordine è stato ricevuto con successo ed è in fase di elaborazione.
            Puoi monitorare lo stato della spedizione direttamente dalla tua area personale.
        </p>

        <div style="display: flex; flex-direction: column; gap: 15px; align-items: center;">
            <a href="<%= request.getContextPath() %>/FatturaServlet?numero_ordine=${param.numero_ordine != null ? param.numero_ordine : sessionScope.ultimoNumeroOrdine}"
               class="confirm-order-btn"
               style="text-decoration: none; display: inline-block; width: auto; padding: 12px 30px; font-size: 16px;">
                Scarica Fattura PDF
            </a>

            <a href="<%= request.getContextPath() %>/catalogo.jsp" style="color: #9BAE73; font-weight: bold; text-decoration: none; font-size: 16px; margin-top: 10px;">
                Torna al Catalogo
            </a>
        </div>
    </div>
</main>

<jsp:include page="footer.jsp" />

</body>
</html>