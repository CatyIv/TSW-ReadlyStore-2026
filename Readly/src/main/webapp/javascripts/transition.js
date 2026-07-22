document.addEventListener("DOMContentLoaded", () => {
    document.body.classList.add("page-loaded");
    document.body.addEventListener("click", (e) => {
        const link = e.target.closest("a");
        if (!link) return;
        if (
            link.target === "_blank" ||
            link.href.startsWith("#") ||
            link.href.startsWith("javascript:") ||
            e.metaKey || e.ctrlKey || e.shiftKey
        ) {
            return;
        }
        e.preventDefault();
        const targetUrl = link.href;
        document.body.classList.add("page-leaving");
        setTimeout(() => {
            window.location.href = targetUrl;
        }, 350);
    });
});
window.addEventListener("pageshow", (event) => {
    if (event.persisted) {
        document.body.classList.remove("page-leaving");
        document.body.classList.add("page-loaded");
    }
});