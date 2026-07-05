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
        inviaInPost("svuota", null, null);
        chiudiPopup();
    } else if (azioneCorrente === "elimina") {
        inviaInPost("rimuovi", isbnDaEliminare, null);
        chiudiPopup();
    } else if (azioneCorrente === "errore_stock") {
        chiudiPopup();
    }
}

function aggiornaQuantita(isbn, nuovaQta, titoloProdotto, maxDisponibile) {
    if (nuovaQta <= 0) {
        chiediConfermaElimina(isbn, titoloProdotto);
    } else if (maxDisponibile !== undefined && maxDisponibile !== null && nuovaQta > maxDisponibile) {
        mostraErroreDisponibilita(maxDisponibile);
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

function gestisciCheckout(event, giaLoggato) {
    if (giaLoggato) {
        return;
    }

    event.preventDefault();

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
        window.location.href = "login.jsp";
    };

    btnSecondary.innerText = "Registrati";
    btnSecondary.onclick = function() {
        window.location.href = "registrazione.jsp";
    };

    overlay.classList.add('active');
}