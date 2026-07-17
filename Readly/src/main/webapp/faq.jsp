<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">4
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FAQ - Readly</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Cabin:wght@700&family=Segoe+UI:wght@400;600;700&display=swap" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20,400,0,0" />
    <link rel="stylesheet" type="text/css" href="stylesheets/faq.css?v=1">
</head>
<body>

<jsp:include page="header.jsp" />

<div class="contenitore-faq">

    <div class="sezione-introduzione">
        <h1 class="titolo-pagina">Domande Frequenti</h1>
        <p class="sottotitolo-pagina">Tutto quello che c'è da sapere sui nostri libri ecologici, spedizioni e ordini.</p>
    </div>

    <div class="lista-faq">

        <details class="item-faq">
            <summary class="domanda-faq">
                <span>Cosa rende i libri di Readly ecologici?</span>
                <span class="material-symbols-outlined freccia-faq">expand_more</span>
            </summary>
            <div class="risposta-faq">
                <p>Tutti i nostri libri, inclusi i best-seller e i titoli più famosi, sono stampati esclusivamente su carta 100% riciclata post-consumo. Inoltre, utilizziamo solo inchiostri biologici a base vegetale che eliminano l'uso di solventi chimici tossici, garantendo un processo di riciclo futuro sicuro e a impatto zero.</p>
            </div>
        </details>

        <details class="item-faq">
            <summary class="domanda-faq">
                <span>I libri ecologici hanno una qualità diversa?</span>
                <span class="material-symbols-outlined freccia-faq">expand_more</span>
            </summary>
            <div class="risposta-faq">
                <p>Assolutamente no! La resa cromatica degli inchiostri biologici e la consistenza della nostra carta riciclata offrono un'esperienza di lettura eccellente, con una definizione dei testi e delle immagini pari (o superiore) ai libri tradizionali.</p>
            </div>
        </details>

        <details class="item-faq">
            <summary class="domanda-faq">
                <span>In quanto tempo viene consegnato un ordine?</span>
                <span class="material-symbols-outlined freccia-faq">expand_more</span>
            </summary>
            <div class="risposta-faq">
                <p>La spedizione standard in tutta Italia richiede solitamente dalle 24 alle 48 ore lavorative. Tutti i nostri pacchi sono spediti all'interno di imballaggi di cartone riciclato senza l'uso di plastica monouso.</p>
            </div>
        </details>

        <details class="item-faq">
            <summary class="domanda-faq">
                <span>Come posso tracciare il mio pacco?</span>
                <span class="material-symbols-outlined freccia-faq">expand_more</span>
            </summary>
            <div class="risposta-faq">
                <p>Una volta spedito l'ordine, riceverai un'email contenente il link di tracciamento del corriere. Potrai monitorare lo stato della consegna in tempo reale anche dalla tua area personale sul nostro sito.</p>
            </div>
        </details>

        <details class="item-faq">
            <summary class="domanda-faq">
                <span>Qual è la vostra politica di reso?</span>
                <span class="material-symbols-outlined freccia-faq">expand_more</span>
            </summary>
            <div class="risposta-faq">
                <p>Se non sei soddisfatto del tuo acquisto, puoi richiedere il reso gratuito entro 14 giorni dalla ricezione del pacco. Il libro deve essere restituito nelle sue condizioni originali. Contatta il nostro supporto web per ricevere l'etichetta di reso.</p>
            </div>
        </details>

    </div>

</div>

<jsp:include page="footer.jsp" />

</body>
</html>