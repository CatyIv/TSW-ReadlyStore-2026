document.addEventListener("DOMContentLoaded", function() {
    const searchBox = document.getElementById('search-box');
    const searchResults = document.getElementById('search-results');

    if (!searchBox || !searchResults) return;

    searchBox.addEventListener('input', function() {
        let query = this.value.trim();
        const contenitore = searchBox.closest('.contenitore-ricerca');
        if (query.length === 0) {
            searchResults.innerHTML = '';
            searchResults.style.display = 'none';
            if (contenitore) contenitore.classList.remove('is-open');
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
                    noResultDiv.style.padding = '10px 20px';
                    searchResults.appendChild(noResultDiv);
                    searchResults.style.display = 'block';
                    if (contenitore) contenitore.classList.add('is-open');
                    return;
                }

                data.forEach(item => {
                    let link = document.createElement('a');
                    link.href = `DettaglioProdottoServlet?isbn=${item.isbn}`;
                    link.textContent = item.titolo;

                    searchResults.appendChild(link);
                });
                searchResults.style.display = 'block';
                if (contenitore) contenitore.classList.add('is-open');
            })
            .catch(error => console.error('Errore AJAX:', error));
    });
});