package control.admin;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.utente.UtenteBean;
import model.utente.UtenteDAO;

@WebServlet("/admin/GestioneUtentiServlet")
public class GestioneUtentiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public GestioneUtentiServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UtenteDAO utenteDAO = new UtenteDAO();
        String action = request.getParameter("action");
        String emailUtente = request.getParameter("emailUtente");

        try {
            if ("cambiaRuolo".equalsIgnoreCase(action) && emailUtente != null) {
                UtenteBean u = utenteDAO.doRetrieveByKey(emailUtente);
                if (u != null) {
                    u.setAdmin(!u.isAdmin());
                    utenteDAO.doUpdate(u);
                }
            }

            List<UtenteBean> listaUtenti = utenteDAO.doRetrieveAll();
            request.setAttribute("listaUtenti", listaUtenti);
            request.getRequestDispatcher("/admin/utenti-admin.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error500.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}