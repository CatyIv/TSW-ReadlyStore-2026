package control;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.ordine.OrdineBean;
import model.ordine.OrdineDAO;
import model.utente.UtenteBean;

@WebServlet("/OrdiniUtenteServlet")
public class OrdiniUtenteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public OrdiniUtenteServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("utente") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        UtenteBean utente = (UtenteBean) session.getAttribute("utente");
        OrdineDAO ordineDAO = new OrdineDAO();

        try {
            List<OrdineBean> listaOrdini = ordineDAO.doRetrieveByUtente(utente.getEmail());
            request.setAttribute("listaOrdini", listaOrdini);

            request.getRequestDispatcher("/ordini-utente.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}