document.addEventListener("DOMContentLoaded", function() {
    const form = document.getElementById("checkoutForm");
    const radioCash = document.getElementById("payment_cash");
    const radioCard = document.getElementById("payment_card");
    const cardDetails = document.getElementById("cardDetails");

    function togglePaymentFields() {
        if (radioCard.checked) {
            cardDetails.style.display = "block";
        } else {
            cardDetails.style.display = "none";
            clearErrors(["cardName", "cardNumber", "expiryDate", "cvv"]);
        }
    }

    if (radioCash && radioCard) {
        radioCash.addEventListener("change", togglePaymentFields);
        radioCard.addEventListener("change", togglePaymentFields);
    }

    function showError(inputId, message) {
        const inputField = document.getElementById(inputId);
        const errorSpan = document.getElementById("err-" + inputId);
        if (inputField && errorSpan) {
            inputField.classList.add("input-error");
            errorSpan.textContent = message;
            errorSpan.style.display = "block";
        }
    }

    function clearError(inputId) {
        const inputField = document.getElementById(inputId);
        const errorSpan = document.getElementById("err-" + inputId);
        if (inputField && errorSpan) {
            inputField.classList.remove("input-error");
            errorSpan.textContent = "";
            errorSpan.style.display = "none";
        }
    }

    function clearErrors(idsArray) {
        idsArray.forEach(id => {
            clearError(id);
            const field = document.getElementById(id);
            if (field) field.value = "";
        });
    }

    function gestisciFiltroNumerico(inputId, regex) {
        const input = document.getElementById(inputId);
        if (input) {
            input.addEventListener("input", function() {
                if (!regex.test(this.value)) {
                    this.value = this.value.replace(/[^0-9]/g, "");
                    showError(inputId, "Questo campo accetta solo numeri.");
                } else {
                    clearError(inputId);
                }
            });
        }
    }

    gestisciFiltroNumerico("cap", /^\d*$/);
    gestisciFiltroNumerico("cardNumber", /^\d*$/);
    gestisciFiltroNumerico("cvv", /^\d*$/);

    const expiryInput = document.getElementById("expiryDate");
    if (expiryInput) {
        expiryInput.addEventListener("input", function() {
            if (!/^[0-9\/]*$/.test(this.value)) {
                this.value = this.value.replace(/[^0-9\/]/g, "");
                showError("expiryDate", "La data accetta solo numeri e il carattere '/'.");
            } else {
                clearError("expiryDate");
            }
        });
    }

    if (form) {
        form.addEventListener("submit", function(event) {
            let isValid = true;

            const destinatario = document.getElementById("destinatario").value.trim();
            if (destinatario.length < 2 || destinatario.length > 40) {
                showError("destinatario", "Il nome deve contenere tra 2 e 40 caratteri.");
                isValid = false;
            } else {
                clearError("destinatario");
            }

            const via = document.getElementById("via").value.trim();
            if (via.length < 2 || via.length > 40) {
                showError("via", "L'indirizzo deve contenere tra 2 e 40 caratteri.");
                isValid = false;
            } else {
                clearError("via");
            }

            const citta = document.getElementById("citta").value.trim();
            if (citta.length < 2 || citta.length > 40) {
                showError("citta", "La città deve contenere tra 2 e 40 caratteri.");
                isValid = false;
            } else {
                clearError("citta");
            }

            const cap = document.getElementById("cap").value.trim();
            const capRegex = /^\d{5}$/;
            if (!capRegex.test(cap)) {
                showError("cap", "Inserisci un CAP valido di 5 cifre numeriche.");
                isValid = false;
            } else {
                clearError("cap");
            }

            if (radioCard && radioCard.checked) {
                const cardName = document.getElementById("cardName").value.trim();
                if (cardName.length < 2 || cardName.length > 40) {
                    showError("cardName", "Il nome del titolare deve contenere tra 2 e 40 caratteri.");
                    isValid = false;
                } else {
                    clearError("cardName");
                }

                const cardNumber = document.getElementById("cardNumber").value.trim();
                const cardRegex = /^\d{16}$/;
                if (!cardRegex.test(cardNumber)) {
                    showError("cardNumber", "Il numero di carta deve contenere esattamente 16 cifre.");
                    isValid = false;
                } else {
                    clearError("cardNumber");
                }

                const expiryDate = document.getElementById("expiryDate").value.trim();
                const expiryRegex = /^(0[1-9]|1[0-2])\/\d{2}$/;
                if (!expiryRegex.test(expiryDate)) {
                    showError("expiryDate", "Formato data non valido. Usa MM/YY.");
                    isValid = false;
                } else {
                    clearError("expiryDate");
                }

                const cvv = document.getElementById("cvv").value.trim();
                const cvvRegex = /^\d{3}$/;
                if (!cvvRegex.test(cvv)) {
                    showError("cvv", "Il codice di sicurezza (CVV) deve essere di 3 cifre.");
                    isValid = false;
                } else {
                    clearError("cvv");
                }
            }

            if (!isValid) {
                event.preventDefault();
            } else {
                event.preventDefault();
                document.body.classList.add("page-leaving");
                setTimeout(function() {
                    form.submit();
                }, 350);
            }
        });
    }
});