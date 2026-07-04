<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Calendar" %>
<link rel="stylesheet" href="<%= request.getContextPath() %>/stylesheets/footer.css">

<footer class="sito-footer">
    <div class="footer-compatto-container">

        <div class="footer-sezione links">
            <a href="CatalogoServlet">
                <span class="material-symbols-outlined">auto_stories</span> Catalogo
            </a>
            <a href="paginaChiSiamo.jsp">
                <span class="material-symbols-outlined">groups</span> Chi Siamo
            </a>
            <a href="contatti.jsp">
                <span class="material-symbols-outlined">mail</span> Contatti
            </a>
            <a href="faq.jsp">
                <span class="material-symbols-outlined">help_center</span> FAQ
            </a>
        </div>

        <div class="footer-sezione social">
            <span class="material-symbols-outlined">share</span>
           <span class="material-symbols-outlined">language</span>
            <a href="profiloUtente.jsp" title="Il mio profilo" aria-label="Profile"><span class="material-symbols-outlined">account_circle</span></a>
        </div>
    </div>

    <div class="footer-diritti">
        <p>&copy; <%= Calendar.getInstance().get(Calendar.YEAR) %> Readly. Tutti i diritti riservati.</p>
    </div>
</footer>