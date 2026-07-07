let currentIndex = 0;

function moveSlider(direction) {
    const wrapper = document.getElementById('sliderWrapper');
    const container = document.querySelector('.banner-slider-container');
    const cards = document.querySelectorAll('.slider-card-only-img');
    if (!wrapper || !container || cards.length === 0) {
        console.error("Carosello: Elementi non trovati nel DOM!");
        return;
    }

    const cardWidth = cards[0].getBoundingClientRect().width + 30;

    const computedStyle = window.getComputedStyle(container);
    const paddingLeft = parseFloat(computedStyle.paddingLeft);
    const paddingRight = parseFloat(computedStyle.paddingRight);
    const visibleWidth = container.clientWidth - (paddingLeft + paddingRight);

    const visibleCards = Math.floor(visibleWidth / cardWidth);
    const maxIndex = cards.length - visibleCards;

    currentIndex += direction;

    if (currentIndex < 0) {
        currentIndex = maxIndex > 0 ? maxIndex : 0;
    } else if (maxIndex > 0 && currentIndex > maxIndex) {
        currentIndex = 0;
    } else if (maxIndex <= 0) {
        currentIndex = 0;
    }

    wrapper.style.transform = `translateX(-${currentIndex * cardWidth}px)`;
}


document.addEventListener("DOMContentLoaded", function () {
    const moduliCatalogo = document.querySelectorAll(".icon-buttons form");

    moduliCatalogo.forEach(form => {
        form.addEventListener("submit", function (event) {
            event.preventDefault();

            const button = this.querySelector("button[type='submit']");
            const titoloLibro = button ? button.getAttribute("data-titolo") : "Prodotto";
            const actionUrl = this.getAttribute("action");

            if (actionUrl.toLowerCase().includes("wishlist")) {
                const loggato = this.getAttribute("data-loggato") === "true";
                if (!loggato) {
                    mostraPopupAuth();
                    return;
                }
            }

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
                            if (badge) {
                                let conteggioAttuale = parseInt(badge.textContent) || 0;
                                badge.textContent = conteggioAttuale + 1;
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
                                    nuovoBadge.textContent = "1";
                                    linkCarrello.appendChild(nuovoBadge);
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