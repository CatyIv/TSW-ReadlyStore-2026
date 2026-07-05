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
<body class="page-checkout" style="background-color: #EADFBC;">

<jsp:include page="header.jsp" />

<main style="display: flex; justify-content: center; align-items: center; min-height: 70vh; padding: 40px 20px; max-width: 1200px; margin: 0 auto; width: 100%;">

    <div style="background-color: #F6F0D7; color: #9BAE73; border-radius: 16px; width: 100%; padding: 40px 60px; display: flex !important; flex-direction: row !important; align-items: center !important; justify-content: space-between !important; gap: 40px !important; text-align: left !important; box-sizing: border-box;">

        <div style="flex: 1 !important; text-align: center !important;">
            <h2 style="font-family: 'Source Sans 3', sans-serif; color: #677351; font-size: 36px; margin-top: 0; margin-bottom: 15px; font-weight: bold;">
                Grazie per il tuo acquisto!
            </h2>
            <p style="font-size: 18px; margin-bottom: 30px; color: #9BAE73; line-height: 1.5;">
                Il tuo ordine è stato ricevuto con successo ed è in fase di elaborazione.
                Puoi monitorare lo stato della spedizione direttamente dalla tua area personale.
            </p>

            <div style="display: flex; flex-direction: column; gap: 15px; align-items: center;">
                <a href="<%= request.getContextPath() %>/FatturaServlet?numero_ordine=${param.numero_ordine != null ? param.numero_ordine : sessionScope.ultimoNumeroOrdine}"
                   class="confirm-order-btn"
                   style="text-decoration: none; display: inline-block; width: auto; padding: 12px 30px; font-size: 16px; font-family: 'Source Sans 3', sans-serif; background-color: #89986D; color: #FFFFFF; font-weight: bold; border: 2px solid #677351; border-radius: 50px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); transition: all 0.3s;">
                    Scarica Fattura PDF
                </a>

                <a href="<%= request.getContextPath() %>/catalogo.jsp" style="color: #677351; font-weight: bold; text-decoration: none; font-size: 18px; margin-top: 10px;">
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

</body>
</html>