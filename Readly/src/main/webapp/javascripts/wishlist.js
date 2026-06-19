document.addEventListener("DOMContentLoaded", function () {
    let formDaEseguire = null;

    document.querySelectorAll(".contenitore-principale-wishlist form").forEach(form => {
        form.addEventListener("submit", function (event) {
            const actionInput = this.querySelector("input[name='action']");
            if (!actionInput) return;

            const action = actionInput.value;

            if (action === "rimuovi") {
                event.preventDefault();
                formDaEseguire = this;
                const titolo = this.closest(".prodotto-card-wish").querySelector(".prodotto-dettagli-testo h3 a").innerText;
                mostraPopupConferma("Rimuovi dai preferiti", `Sei sicuro di voler rimuovere <strong>'${titolo}'</strong> dalla tua wishlist?`, "Rimuovi");
            } else if (action === "svuota") {
                event.preventDefault();
                formDaEseguire = this;
                mostraPopupConferma("Svuota Wishlist", "Sei sicuro di voler rimuovere tutti i libri dai tuoi preferiti?", "Svuota");
            } else if (action === "aggiungi") {
                event.preventDefault();
                eseguiAzioneAjax(this, true);
            }
        });
    });

    document.getElementById("wishlist-btn-conferma").addEventListener("click", function () {
        if (formDaEseguire) {
            eseguiAzioneAjax(formDaEseguire, false);
            chiudiPopupOperazione();
        }
    });
});

function eseguiAzioneAjax(form, isAggiuntaCarrello) {
    const url = form.getAttribute("action");
    const formData = new FormData(form);

    fetch(url, {
        method: "POST",
        body: new URLSearchParams(formData)
    })
        .then(response => {
            if (response.ok) {
                if (isAggiuntaCarrello) {
                    const titolo = form.closest(".prodotto-card-wish").querySelector(".prodotto-dettagli-testo h3 a").innerText;
                    mostraPopupNotifica("Aggiunto al Carrello!", `Il libro <strong>'${titolo}'</strong> è stato inserito nel carrello con successo.`);
                } else {
                    window.location.reload();
                }
            } else {
                alert("Si è verificato un errore sul server (Codice: " + response.status + ").");
            }
        })
        .catch(error => {
            console.error("Errore AJAX:", error);
            alert("Errore di connessione o di esecuzione dello script.");
        });
}

function mostraPopupConferma(titolo, descrizione, testoBottone) {
    document.getElementById("wishlist-modal-title").innerText = titolo;
    document.getElementById("wishlist-modal-description").innerHTML = descrizione;
    document.getElementById("wishlist-btn-conferma").innerText = testoBottone;

    document.getElementById("wishlist-btn-conferma").style.display = "inline-block";
    document.getElementById("wishlist-btn-annulla").innerText = "Annulla";
    document.getElementById("wishlist-popup-overlay").classList.add("active");
}

function mostraPopupNotifica(titolo, descrizione) {
    document.getElementById("wishlist-modal-title").innerText = titolo;
    document.getElementById("wishlist-modal-description").innerHTML = descrizione;

    document.getElementById("wishlist-btn-conferma").style.display = "none";
    document.getElementById("wishlist-btn-annulla").innerText = "Continua lo shopping";
    document.getElementById("wishlist-popup-overlay").classList.add("active");
}

function chiudiPopupOperazione() {
    document.getElementById("wishlist-popup-overlay").classList.remove("active");
}