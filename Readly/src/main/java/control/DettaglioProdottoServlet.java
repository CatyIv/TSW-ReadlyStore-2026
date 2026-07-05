package control;

import model.prodotto.ProdottoBean;
import model.prodotto.ProdottoDAO;
import model.immagine.ImmagineBean;
import model.immagine.ImmagineDAO;
import javax.servlet.http.HttpSession;
import model.carrello.CarrelloBean;
import model.itemcarrello.ItemCarrelloBean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;



@WebServlet("/DettaglioProdottoServlet")
public class DettaglioProdottoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProdottoDAO prodottoDAO;
    private ImmagineDAO immagineDAO;
    public void init() throws ServletException {
        super.init();
        prodottoDAO = new ProdottoDAO();
        immagineDAO = new ImmagineDAO();
    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!model.ConnectionPool.isInitialized()) {
            try {
                model.ConnectionPool.init(10);
                System.out.println("[Servlet] Connection Pool inizializzato al volo!");
            } catch (java.sql.SQLException e) {
                System.err.println("[Servlet] Errore critico di inizializzazione del pool!");
                e.printStackTrace();
            }
        }
        String isbnParam = request.getParameter("isbn");
        if (isbnParam == null || isbnParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ISBN mancante.");
            return;
        }
        try {
            ProdottoBean libro = prodottoDAO.doRetrieveByKey(isbnParam);
            if (libro == null) {
              request.setAttribute("messaggioErrore", "Il libro richiesto non esiste o non è più disponibile");
              request.getRequestDispatcher("/erroreProdotto.jsp").forward(request,response);
            }
            List<ImmagineBean> listaImmagini = immagineDAO.doRetrieveByProdotto(isbnParam);
            String immaginePrincipale = "default_book.png";
            if (listaImmagini != null && !listaImmagini.isEmpty()) {
                immaginePrincipale = listaImmagini.get(0).getUrl();
            }
            HttpSession session = request.getSession();
            boolean utenteLoggato = (session.getAttribute("utente") != null);

            CarrelloBean carrelloDettaglio = (CarrelloBean) session.getAttribute("carrello");
            int copieGiaNelCarrello = 0;
            if (carrelloDettaglio != null && carrelloDettaglio.getItems() != null) {
                for (ItemCarrelloBean item : carrelloDettaglio.getItems()) {
                    if (item.getProdotto().getIsbn().equals(libro.getIsbn())) {
                        copieGiaNelCarrello = item.getQuantita();
                        break;
                    }
                }
            }
            int copieDisponibiliEffettive = libro.getDisponibilita() - copieGiaNelCarrello;
            request.setAttribute("libro", libro);
            request.setAttribute("listaImmagini", listaImmagini);
            request.setAttribute("immaginePrincipale", immaginePrincipale);
            request.getRequestDispatcher("/dettaglioProdotto.jsp").forward(request, response);
        } catch (SQLException e) {
            System.err.println("Errore SQL nel dettaglio prodotto: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore interno del database.");
        }
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
