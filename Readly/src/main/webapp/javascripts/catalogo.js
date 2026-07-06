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
        currentIndex = 0;
    } else if (maxIndex > 0 && currentIndex > maxIndex) {
        currentIndex = maxIndex;
    } else if (maxIndex <= 0) {
        currentIndex = 0;
    }

    wrapper.style.transform = `translateX(-${currentIndex * cardWidth}px)`;
}