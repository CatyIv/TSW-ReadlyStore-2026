package control;

import model.utente.UtenteBean;
import model.utente.UtenteDAO;
import model.carrello.CarrelloBean;
import model.carrello.CarrelloDAO;

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
        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("utente") != null) {
            UtenteBean utente = (UtenteBean) session.getAttribute("utente");
            if (utente.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/DashboardServlet");
            }  else {
                response.sendRedirect(request.getContextPath() + "/AreaPersonaleServlet");
            }
            return;
        }
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

                    try {
                        CarrelloDAO carrelloDAO = new CarrelloDAO();
                        CarrelloBean carrello = carrelloDAO.doRetrieveByUtente(email);

                        if (carrello == null) {
                            carrello = new CarrelloBean();
                            carrello.setIdCarrello(java.util.UUID.randomUUID().toString());
                            carrelloDAO.doSave(carrello, email);
                        }

                        CarrelloServlet.mergeGuestCartToUserCart(request, response, utente);
                        carrelloDAO.caricaElementiCarrello(carrello);

                        session.setAttribute("carrello", carrello);
                        int conteggioBadge = (carrello.getItems() != null) ? carrello.getItems().size() : 0;
                        session.setAttribute("cartCount", conteggioBadge);

                    } catch (SQLException e) {
                        logger.log(Level.SEVERE, "Errore nel caricamento del carrello per l'utente: " + email, e);
                    }

                    if (utente.isAdmin()) {
                        response.sendRedirect(request.getContextPath() + "/admin/DashboardServlet");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/CatalogoServlet");
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