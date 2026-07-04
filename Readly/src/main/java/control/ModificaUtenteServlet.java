package control;

import java.io.IOException;
import java.sql.SQLException;
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

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/AreaPersonaleServlet");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UtenteBean utente = (UtenteBean) session.getAttribute("utente");

        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/auth.jsp");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String telefono = request.getParameter("telefono");

        if (nome != null && !nome.trim().isEmpty() &&
                cognome != null && !cognome.trim().isEmpty() &&
                telefono != null && !telefono.trim().isEmpty()) {

            utente.setNome(nome.trim());
            utente.setCognome(cognome.trim());
            utente.setTelefono(telefono.trim());

            try {
                UtenteDAO utenteDao = new UtenteDAO();
                utenteDao.doUpdateAnagrafica(utente);

                session.setAttribute("utente", utente);

            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/AreaPersonaleServlet?action=edit&error=db");
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/AreaPersonaleServlet");
    }
}