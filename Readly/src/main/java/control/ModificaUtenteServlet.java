package control;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.utente.UtenteBean;
import model.utente.UtenteDAO;

@WebServlet("/ModificaUtenteServlet")
public class ModificaUtenteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final Pattern TELEFONO_PATTERN = Pattern.compile("^\\+\\d{1,13}$");

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/AreaPersonaleServlet");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UtenteBean utente = (UtenteBean) session.getAttribute("utente");

        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        List<String> errorMessages = new ArrayList<>();

        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String telefono = request.getParameter("telefono");

        if (nome == null || nome.trim().isEmpty()) {
            errorMessages.add("Campo nome obbligatorio.");
        }

        if (cognome == null || cognome.trim().isEmpty()) {
            errorMessages.add("Campo cognome obbligatorio.");
        }

        if (telefono == null || telefono.trim().isEmpty()) {
            errorMessages.add("Campo telefono obbligatorio.");
        } else if (!TELEFONO_PATTERN.matcher(telefono.trim()).matches()) {
            errorMessages.add("Il numero di telefono deve contenere il prefisso e 10 cifre (es. +393331234567).");
        }

        if (!errorMessages.isEmpty()) {
            request.setAttribute("errorMessage", String.join("<br>", errorMessages));
            request.getRequestDispatcher("/AreaPersonaleServlet?action=edit").forward(request, response);
            return;
        }

        utente.setNome(nome.trim());
        utente.setCognome(cognome.trim());
        utente.setTelefono(telefono.trim());

        try {
            UtenteDAO utenteDao = new UtenteDAO();
            utenteDao.doUpdateAnagrafica(utente);

            session.setAttribute("utente", utente);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Errore interno del database. Riprova più tardi.");
            request.getRequestDispatcher("/AreaPersonaleServlet?action=edit").forward(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/AreaPersonaleServlet");
    }
}