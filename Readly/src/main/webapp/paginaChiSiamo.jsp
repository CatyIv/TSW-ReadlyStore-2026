<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Siamo - Readly</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Cabin:wght@700&family=Segoe+UI:wght@400;600;700&display=swap" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20,400,0,0" />
    <link rel="stylesheet" type="text/css" href="stylesheets/chiSiamo.css?v=2">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/bottone.css">

</head>
<body>

<jsp:include page="header.jsp" />

<div class="contenitore-chi-siamo">

    <div class="sezione-introduzione">
        <h1 class="titolo-pagina">Chi Siamo</h1>
        <p class="sottotitolo-pagina">Grandi storie, zero impatto. Il futuro della lettura è rigenerativo.</p>

        <div class="testo-principale">
            <p>
                Benvenuto su <strong>Readly</strong>. Siamo una libreria online nata con una missione chiara:
                rendere accessibili i capolavori della letteratura mondiale e le ultime novità editoriali,
                senza gravare sul nostro pianeta. Crediamo che la cultura e la conoscenza siano strumenti fondamentali
                per il cambiamento, ma crediamo anche che il modo in cui produciamo e diffondiamo queste idee debba
                rispecchiare il massimo rispetto per la biosfera.
            </p>
            <p>
                Selezioniamo i titoli più amati, famosi e ricercati, ma lo facciamo con una svolta ecologica radicale:
                ogni singolo volume presente nel nostro catalogo è stampato esclusivamente su <strong>carta 100% riciclata
                post-consumo</strong> e utilizzando <strong>inchiostri biologici a base vegetale</strong> che non rilasciano
                sostanze tossiche e non danneggiano l'ambiente.
            </p>
        </div>
    </div>

    <div class="griglia-valori">
        <div class="card-valore">
            <span class="material-symbols-outlined icona-valore">eco</span>
            <h3>Inchiostri Biologici</h3>
            <p>Utilizziamo pigmenti naturali e basi vegetali non inquinanti, garantendo una perfetta resa cromatica e una biodegradabilità totale.</p>
        </div>

        <div class="card-valore">
            <span class="material-symbols-outlined icona-valore">recycling</span>
            <h3>100% Carta Riciclata</h3>
            <p>Nessun albero viene abbattuto per i nostri libri. Sosteniamo l'economia circolare riducendo drasticamente il consumo idrico ed energetico.</p>
        </div>

        <div class="card-valore">
            <span class="material-symbols-outlined icona-valore">co2</span>
            <h3>Impronta Neutra</h3>
            <p>Compensiamo ogni singola emissione legata al trasporto e alla logistica, investendo in progetti di riforestazione certificati.</p>
        </div>
    </div>

    <div class="sezione-etica">
        <h2 class="titolo-sezione">Il Nostro Manifesto Etico</h2>
        <p class="descrizione-etica">
            Operiamo in un momento storico di grande crisi climatica e sociale. Per questo, Readly si impegna
            a seguire linee guida rigide che mettono al centro l'inclusione, la trasparenza e la giustizia ambientale.
        </p>

        <ul class="lista-punti-etici">
            <li>
                <strong>Inclusione e Rispetto:</strong> Promuoviamo e celebriamo la diversità in ogni sua forma (genere, etnia, orientamento, abilità ed età), sia all'interno del nostro team che nella selezione dei contenuti.
            </li>
            <li>
                <strong>Rifiuto di ogni Discriminazione:</strong> Non tolleriamo espressioni d'odio, razzismo, sessismo o omofobia. La nostra piattaforma è e sarà sempre uno spazio sicuro per il dialogo costruttivo.
            </li>
            <li>
                <strong>Trasparenza di Filiera:</strong> Collaboriamo solo con stampatori e partner logistici che condividono i nostri standard ecologici e che garantiscono condizioni di lavoro eque e sicure.
            </li>
            <li>
                <strong>Oltre il profitto:</strong> Riteniamo che la vera prosperità non si misuri solo in termini finanziari. Proteggiamo il benessere economico dell'azienda per garantire continuità alle future generazioni, coltivando l'equilibrio tra lavoro e vita privata del nostro team.
            </li>
        </ul>
    </div>

</div>

<jsp:include page="footer.jsp" />
<jsp:include page="bottone.jsp" />

<script src="${pageContext.request.contextPath}/javascripts/bottone.js"></script>


</body>
</html>