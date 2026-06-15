package control;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.carrello.CarrelloBean;
import model.carrello.CarrelloDAO;
import model.itemcarrello.ItemCarrelloDAO;
import model.prodotto.ProdottoBean;
import model.prodotto.ProdottoDAO;
import model.utente.UtenteBean;

@WebServlet("/CarrelloServlet")
public class CarrelloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final CarrelloDAO carrelloDao = new CarrelloDAO();
    private final ItemCarrelloDAO itemCarrelloDao = new ItemCarrelloDAO();
    private final ProdottoDAO prodottoDao = new ProdottoDAO();

    public CarrelloServlet() {
        super();
    }

    @SuppressWarnings({"CallToPrintStackTrace", "override"})
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        UtenteBean utenteLoggato = (UtenteBean) session.getAttribute("utente");
        
        if (utenteLoggato == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        CarrelloBean carrello = (CarrelloBean) session.getAttribute("carrello");
        if (carrello == null) {
            carrello = new CarrelloBean();
            session.setAttribute("carrello", carrello);
        }

        String action = request.getParameter("action");
        String isbn = request.getParameter("isbn");

        try {
            if (action != null) {
                
                if (action.equalsIgnoreCase("aggiungi")) {
                    String qtaParam = request.getParameter("quantita");
                    int qta = (qtaParam != null) ? Integer.parseInt(qtaParam) : 1;
                    
                    ProdottoBean prodotto = prodottoDao.doRetrieveByKey(isbn);

                    if (prodotto != null) {
                        carrello.aggiungiProdotto(prodotto, qta);
                        
                        if (carrello.getIdCarrello() != null) {
                            itemCarrelloDao.doSave(carrello.getIdCarrello(), isbn, qta);
                        }
                    }
                }
                
                else if (action.equalsIgnoreCase("modifica")) {
                    int nuovaQta = Integer.parseInt(request.getParameter("quantita"));
                    
                    carrello.modificaQuantita(isbn, nuovaQta);
                    
                    if (carrello.getIdCarrello() != null) {
                        if (nuovaQta <= 0) {
                            itemCarrelloDao.doDelete(carrello.getIdCarrello(), isbn);
                        } else {
                            itemCarrelloDao.doUpdate(carrello.getIdCarrello(), isbn, nuovaQta);
                        }
                    }
                }
                
                else if (action.equalsIgnoreCase("rimuovi")) {
                    carrello.rimuoviProdotto(isbn);
                    
                    if (carrello.getIdCarrello() != null) {
                        itemCarrelloDao.doDelete(carrello.getIdCarrello(), isbn);
                    }
                }
                
                else if (action.equalsIgnoreCase("svuota")) {
                    carrello.svuotaCarrello();
                    
                    if (carrello.getIdCarrello() != null) {
                        carrelloDao.doClear(carrello.getIdCarrello());
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
            return;
        }

        response.sendRedirect("carrello.jsp");
    }

    @SuppressWarnings("override")
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}