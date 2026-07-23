let azioneCorrente = "";
let isbnDaEliminare = "";

function chiediConfermaSvuota() {
    azioneCorrente = "svuota";
    document.getElementById('modal-title').innerText = "Sei sicuro di voler svuotare il carrello?";
    document.getElementById('modal-description').innerText = "Questa azione rimuoverà permanentemente tutti i libri che hai selezionato.";
    document.getElementById('modal-btn-action').innerText = "Sì, svuota tutto";
    document.getElementById('modal-btn-secondary').innerText = "Annulla";
    document.getElementById('custom-confirm-overlay').classList.add('active');
}

function chiediConfermaElimina(isbn, titolo) {
    azioneCorrente = "elimina";
    isbnDaEliminare = isbn;
    document.getElementById('modal-title').innerText = "Rimuovere questo libro?";
    document.getElementById('modal-description').innerText = "Stai per togliere '" + titolo + "' dal tuo carrello.";
    document.getElementById('modal-btn-action').innerText = "Sì, rimuovi";
    document.getElementById('modal-btn-secondary').innerText = "Annulla";
    document.getElementById('custom-confirm-overlay').classList.add('active');
}

function mostraErroreDisponibilita(maxDisponibile) {
    azioneCorrente = "errore_stock";
    document.getElementById('modal-title').innerText = "Disponibilità Insufficiente";
    document.getElementById('modal-description').innerText = "Non puoi aggiungere altre copie di questo libro. Il numero massimo di copie disponibili in magazzino è " + maxDisponibile + ".";
    document.getElementById('modal-btn-action').innerText = "Ok, ho capito";
    document.getElementById('modal-btn-secondary').style.display = "none";
    document.getElementById('custom-confirm-overlay').classList.add('active');
}

function chiudiPopup() {
    document.getElementById('custom-confirm-overlay').classList.remove('active');
    document.getElementById('modal-btn-secondary').style.display = "";
    document.getElementById('modal-btn-secondary').innerText = "";
    azioneCorrente = "";
    isbnDaEliminare = "";
}

function eseguiAzioneConfermata() {
    if (azioneCorrente === "svuota") {
        inviaInFetch("svuota", null, null);
        chiudiPopup();
    } else if (azioneCorrente === "elimina") {
        inviaInFetch("rimuovi", isbnDaEliminare, null);
        chiudiPopup();
    } else if (azioneCorrente === "errore_stock") {
        chiudiPopup();
    } else if (azioneCorrente === "richiedi_autenticazione") {
        chiudiPopup();
        window.location.href = "login.jsp";
    }
}

function aggiornaQuantita(isbn, segno, titoloProdotto, maxDisponibile) {
    const qtaSpan = document.getElementById("qta-" + isbn);
    if (!qtaSpan) return;

    let qtaAttuale = parseInt(qtaSpan.innerText) || 1;
    let nuovaQta = qtaAttuale;

    if (segno === '+') {
        nuovaQta = qtaAttuale + 1;
    } else if (segno === '-') {
        nuovaQta = qtaAttuale - 1;
    }

    if (nuovaQta <= 0) {
        chiediConfermaElimina(isbn, titoloProdotto);
    } else if (maxDisponibile !== undefined && maxDisponibile !== null && nuovaQta > maxDisponibile) {
        mostraErroreDisponibilita(maxDisponibile);
    } else {
        inviaInFetch("modifica", isbn, nuovaQta);
    }
}

function inviaInFetch(azione, isbn, quantita) {
    let urlParams = new URLSearchParams();
    urlParams.append("action", azione);
    urlParams.append("ajax", "true");
    if (isbn) urlParams.append("isbn", isbn);
    if (quantita !== null && quantita !== undefined) urlParams.append("quantita", quantita);

    let contextPath = window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1));
    let targetUrl = (contextPath ? contextPath : "") + "/CarrelloServlet";

    fetch(targetUrl, {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: urlParams.toString()
    })
        .then(response => {
            if (!response.ok) throw new Error("Errore di rete");
            return response.json();
        })
        .then(data => {
            if (data.status === "success") {
                if (data.isEmpty || azione === "svuota") {
                    window.location.reload();
                    return;
                }

                if (azione === "rimuovi" && isbn) {
                    let elementoCard = document.getElementById("qta-" + isbn)?.closest(".prodotto-card-wish") ||
                        document.getElementById("prezzo-" + isbn)?.closest(".prodotto-card-wish") ||
                        document.querySelector(`[id*="${isbn}"]`)?.closest(
                            ".prodotto-card-wish, .item-carrello, .prodotto-card, tr"
                        );

                    if (elementoCard) {
                        elementoCard.remove();
                    } else {
                        window.location.reload();
                        return;
                    }
                }

                let badge = document.getElementById("cart-badge") || document.querySelector(".conteggio-badge");
                if (badge) badge.innerText = data.cartCount;

                if (azione === "modifica" && isbn && quantita) {
                    let qtaSpan = document.getElementById("qta-" + isbn);
                    if (qtaSpan) qtaSpan.innerText = quantita;

                    let prezzoDiv = document.getElementById("prezzo-" + isbn);
                    if (prezzoDiv) prezzoDiv.innerText = data.itemPrezzoTotale;
                }

                let articoliSpan = document.querySelector(".riepilogo-articoli span:last-child");
                if (articoliSpan) articoliSpan.innerText = data.cartCount;

                let imponibileSpan = document.querySelector(".riepilogo-imponibile span:last-child");
                if (imponibileSpan) imponibileSpan.innerText = data.imponibile;

                let ivaSpan = document.querySelector(".riepilogo-iva span:last-child");
                if (ivaSpan) ivaSpan.innerText = data.quotaIva;

                let totaleDefinitivoSpan = document.querySelector(".totale-definitivo span:last-child");
                if (totaleDefinitivoSpan) totaleDefinitivoSpan.innerText = data.totaleDefinitivo;
            }
        })
        .catch(error => {
            console.error("Errore Fetch:", error);
        });
}

function gestisciCheckout(event, giaLoggato) {
    if (giaLoggato) {
        return;
    }

    event.preventDefault();
    event.stopPropagation();
    event.stopImmediatePropagation();

    azioneCorrente = "richiedi_autenticazione";

    const overlay = document.getElementById('custom-confirm-overlay');
    const title = document.getElementById('modal-title');
    const description = document.getElementById('modal-description');
    const btnAction = document.getElementById('modal-btn-action');
    const btnSecondary = document.getElementById('modal-btn-secondary');

    if (!overlay || !title || !description || !btnAction || !btnSecondary) {
        return;
    }

    title.innerText = "Autenticazione Richiesta";
    description.innerText = "Prima di effettuare il checkout, accedi al tuo account o creane uno nuovo.";

    btnAction.innerText = "Accedi";
    btnAction.onclick = function() {
        chiudiPopup();
        window.location.href = "login.jsp";
    };

    btnSecondary.innerText = "Registrati";
    btnSecondary.onclick = function() {
        chiudiPopup();
        window.location.href = "registrazione.jsp";
    };

    overlay.classList.add('active');
}