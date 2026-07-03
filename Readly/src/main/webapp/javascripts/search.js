document.addEventListener("DOMContentLoaded", function() {
    const searchBox = document.getElementById('search-box');
    const searchResults = document.getElementById('search-results');

    if (!searchBox || !searchResults) return;

    searchBox.addEventListener('input', function() {
        let query = this.value.trim();

        if (query.length === 0) {
            searchResults.innerHTML = '';
            searchResults.style.display = 'none';
            return;
        }

        let contextPath = window.location.pathname.split('/')[1];

        fetch(`/${contextPath}/SearchServlet?search=${encodeURIComponent(query)}`)
            .then(response => response.json())
            .then(data => {
                searchResults.innerHTML = '';

                if (data.length === 0) {
                    let noResultDiv = document.createElement('div');
                    noResultDiv.textContent = 'Nessun prodotto trovato';
                    noResultDiv.style.padding = '10px 20px'; // Un po' di spazio temporaneo
                    searchResults.appendChild(noResultDiv);
                    searchResults.style.display = 'block'; // <-- AGGIUNGI QUESTO
                    return;
                }

                data.forEach(item => {
                    let link = document.createElement('a');
                    link.href = `DettaglioProdottoServlet?isbn=${item.isbn}`;
                    link.textContent = item.titolo;

                    searchResults.appendChild(link);
                });
                searchResults.style.display = 'block';
            })
            .catch(error => console.error('Errore AJAX:', error));
    });
});