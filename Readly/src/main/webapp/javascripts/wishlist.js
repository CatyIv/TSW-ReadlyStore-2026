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

    formData.append("ajax", "true");

    fetch(url, {
        method: "POST",
        body: new URLSearchParams(formData)
    })
        .then(response => {
            if (!response.ok) {
                throw new Error("Errore di rete");
            }
            return response.json();
        })
        .then(data => {
            if (isAggiuntaCarrello) {
                const titolo = form.closest(".prodotto-card-wish").querySelector(".prodotto-dettagli-testo h3 a").innerText;
                mostraPopupNotifica("Aggiunto al Carrello!", `Il libro <strong>'${titolo}'</strong> è stato inserito nel carrello con successo.`);

                let badge = document.querySelector(".conteggio-badge");
                const quantitaInput = form.querySelector("input[name='quantita']");
                const quantitaAggiunta = quantitaInput ? parseInt(quantitaInput.value) : 1;

                if (badge) {
                    let conteggioAttuale = parseInt(badge.textContent) || 0;
                    badge.textContent = conteggioAttuale + quantitaAggiunta;
                } else {
                    const iconeHeader = document.querySelectorAll(".collegamento-icona");
                    let linkCarrello = null;

                    iconeHeader.forEach(icona => {
                        if (icona.innerHTML.includes("shopping_cart")) {
                            linkCarrello = icona;
                        }
                    });

                    if (linkCarrello) {
                        const nuovoBadge = document.createElement("span");
                        nuovoBadge.className = "conteggio-badge";
                        nuovoBadge.textContent = quantitaAggiunta;
                        linkCarrello.appendChild(nuovoBadge);
                    }
                }
            } else {
                if (data.status === "success") {
                    if (data.action === "rimuovi") {
                        const cardElement = document.querySelector(`.prodotto-card-wish[data-isbn='${data.isbn}']`);
                        if (cardElement) {
                            cardElement.remove();
                        }

                        const rimanenti = document.querySelectorAll(".prodotto-card-wish");
                        if (rimanenti.length === 0) {
                            window.location.reload();
                        }
                    } else if (data.action === "svuota") {
                        window.location.reload();
                    }
                } else {
                    alert("Errore durante l'operazione: " + (data.message || "riprova più tardi."));
                }
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