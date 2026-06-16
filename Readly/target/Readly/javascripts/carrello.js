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
        inviaInPost("svuota", null, null);
    } else if (azioneCorrente === "elimina") {
        inviaInPost("rimuovi", isbnDaEliminare, null);
    }
    chiudiPopup();
}

function aggiornaQuantita(isbn, nuovaQta, titoloProdotto) {
    if (nuovaQta <= 0) {
        chiediConfermaElimina(isbn, titoloProdotto);
    } else {
        inviaInPost("modifica", isbn, nuovaQta);
    }
}

function inviaInPost(azione, isbn, quantita) {
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = 'CarrelloServlet';

    const inputAction = document.createElement('input');
    inputAction.type = 'hidden';
    inputAction.name = 'action';
    inputAction.value = azione;
    form.appendChild(inputAction);

    if (isbn) {
        const inputIsbn = document.createElement('input');
        inputIsbn.type = 'hidden';
        inputIsbn.name = 'isbn';
        inputIsbn.value = isbn;
        form.appendChild(inputIsbn);
    }

    if (quantita !== null && quantita !== undefined) {
        const inputQta = document.createElement('input');
        inputQta.type = 'hidden';
        inputQta.name = 'quantita';
        inputQta.value = quantita;
        form.appendChild(inputQta);
    }

    document.body.appendChild(form);
    form.submit();
}