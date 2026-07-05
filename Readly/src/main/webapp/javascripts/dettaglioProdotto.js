document.addEventListener("DOMContentLoaded", function () {
    const moduli = document.querySelectorAll(".riga-bottoni-finali form");
    const titoloLibro = document.querySelector(".titolo-libro") ? document.querySelector(".titolo-libro").innerText : "Prodotto";

    moduli.forEach(form => {
        form.addEventListener("submit", function (event) {
            event.preventDefault();

            if (this.classList.contains("form-wishlist")) {
                const loggato = this.getAttribute("data-loggato") === "true";
                if (!loggato) {
                    mostraPopupAuth();
                    return;
                }
            }

            const actionUrl = this.getAttribute("action");
            const formData = new FormData(this);

            fetch(actionUrl, {
                method: "POST",
                body: new URLSearchParams(formData)
            })
                .then(response => {
                    if (response.url && response.url.includes("login.jsp")) {
                        mostraPopupAuth();
                        return;
                    }

                    if (response.ok) {
                        const isWishlist = actionUrl.toLowerCase().includes("wishlist");
                        mostraPopupSuccesso(titoloLibro, isWishlist);

                        if (!isWishlist) {
                            let badge = document.querySelector(".conteggio-badge");
                            const quantitaInput = document.getElementById('quantita');
                            const bottoneCarrello = document.querySelector('.bottone-carrello');
                            const divStato = document.querySelector('.stato-disponibilita');
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

                            if (quantitaInput && bottoneCarrello) {
                                const maxAttuale = parseInt(quantitaInput.getAttribute('max')) || 0;
                                const nuovoMax = maxAttuale - quantitaAggiunta;

                                if (nuovoMax <= 0) {
                                    quantitaInput.value = 0;
                                    quantitaInput.setAttribute('min', 0);
                                    quantitaInput.setAttribute('max', 0);
                                    quantitaInput.disabled = true;
                                    bottoneCarrello.disabled = true;

                                    if (divStato) {
                                        divStato.classList.add('esaurito');
                                        divStato.innerHTML = "Quantità massima già nel carrello";
                                    }
                                } else {
                                    quantitaInput.setAttribute('max', nuovoMax);
                                    quantitaInput.value = 1;
                                }
                            }
                        }

                    } else {
                        alert("Si è verificato un errore sul server (Codice: " + response.status + ").");
                    }
                })
                .catch(error => {
                    console.error("Errore AJAX:", error);
                    alert("Errore di connessione o di esecuzione dello script.");
                });
        });
    });
});

function mostraPopupSuccesso(titolo, isWishlist) {
    const overlay = document.getElementById("success-popup-overlay");
    const modalTitle = document.getElementById("success-modal-title");
    const modalDesc = document.getElementById("success-modal-description");

    if (isWishlist) {
        modalTitle.innerText = "Aggiunto alla Wishlist!";
        modalDesc.innerHTML = `Ora <strong>'${titolo}'</strong> è tra i tuoi preferiti!`;
    } else {
        modalTitle.innerText = "Aggiunto al Carrello!";
        modalDesc.innerHTML = `Il libro <strong>'${titolo}'</strong> è stato inserito nel carrello con successo.`;
    }

    overlay.classList.add("active");
}

function chiudiPopupSuccesso() {
    document.getElementById("success-popup-overlay").classList.remove("active");
}

function mostraPopupAuth() {
    document.getElementById("auth-popup-overlay").classList.add("active");
}

function chiudiPopupAuth(event) {
    if (event) {
        document.getElementById("auth-popup-overlay").classList.remove("active");
    }
}