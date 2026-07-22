document.addEventListener("DOMContentLoaded", function () {
    const btnTop = document.getElementById("btn-top");

    if (btnTop) {
        // Mostra o nasconde il pulsante in base allo scroll (300px)
        window.addEventListener("scroll", function () {
            if (window.scrollY > 300) {
                btnTop.classList.add("visibile");
            } else {
                btnTop.classList.remove("visibile");
            }
        });

        // Torna in cima con animazione fluida al click
        btnTop.addEventListener("click", function () {
            window.scrollTo({
                top: 0,
                behavior: "smooth"
            });
        });
    }
});