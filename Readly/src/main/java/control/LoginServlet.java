package control;

import model.utente.UtenteBean;
import model.utente.UtenteDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final Logger logger = Logger.getLogger(LoginServlet.class.getName());

    public LoginServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Inserire email e password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        UtenteDAO utenteDAO = new UtenteDAO();

        try {
            UtenteBean utente = utenteDAO.doRetrieveByKey(email);

            if (utente != null) {
                String hashedInputPassword = Security.hashPassword(password);

                if (utente.getPassword().equals(hashedInputPassword)) {

                    HttpSession session = request.getSession(true);
                    session.setAttribute("utente", utente);
                    logger.info("Utente autenticato con successo: " + email);

                    if (utente.isAdmin()) {
                        response.sendRedirect(request.getContextPath() + "/admin/DashboardServlet");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/index.jsp");
                    }
                    return;

                } else {
                    request.setAttribute("errorMessage", "Credenziali non valide. Riprova.");
                }
            } else {
                request.setAttribute("errorMessage", "Credenziali non valide. Riprova.");
            }

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Errore SQL durante la fase di login per l'utente: " + email, e);
            request.setAttribute("errorMessage", "Si è verificato un errore interno del server. Riprova più tardi.");
        }

        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
}