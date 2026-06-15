let azioneCorrente = "";
let isbnDaEliminare = "";

function chiediConfermaSvuota() {
    azioneCorrente = "svuota";
    document.getElementById('modal-title').innerText = "Sei sicuro di voler svuotare il carrello?";
    document.getElementById('modal-description').innerText = "Questa azione rimuoverà permanentemente tutti i libri che hai selezionato.";
    document.getElementById('modal-btn-action').innerText = "Sì, svuota tutto";
    document.getElementById('custom-confirm-overlay').classList.add('active');
}

function chiediConfermaElimina(isbn, titolo) {
    azioneCorrente = "elimina";
    isbnDaEliminare = isbn;
    document.getElementById('modal-title').innerText = "Rimuovere questo libro?";
    document.getElementById('modal-description').innerText = "Stai per togliere '" + titolo + "' dal tuo carrello.";
    document.getElementById('modal-btn-action').innerText = "Sì, rimuovi";
    document.getElementById('custom-confirm-overlay').classList.add('active');
}

function chiudiPopup() {
    document.getElementById('custom-confirm-overlay').classList.remove('active');
    azioneCorrente = "";
    isbnDaEliminare = "";
}

function eseguiAzioneConfermata() {
    if (azioneCorrente === "svuota") {
        window.location.href = "CarrelloServlet?action=svuota";
    } else if (azioneCorrente === "elimina") {
        window.location.href = "CarrelloServlet?action=rimuovi&isbn=" + isbnDaEliminare;
    }
}

function aggiornaQuantita(isbn, nuovaQta) {
    if (nuovaQta <= 0) {
        let card = event.target.closest('.prodotto-card');
        let titolo = "questo libro";
        if (card) {
            let h3 = card.querySelector('.prodotto-dettagli-testo h3');
            if (h3) titolo = h3.innerText;
        }
        chiediConfermaElimina(isbn, titolo);
    } else {
        window.location.href = "CarrelloServlet?action=modifica&isbn=" + isbn + "&quantita=" + nuovaQta;
    }
}