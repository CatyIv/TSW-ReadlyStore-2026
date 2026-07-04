package control;

import model.carrello.CarrelloBean;
import model.itemcarrello.ItemCarrelloBean;
import model.ordine.OrdineBean;
import model.ordine.OrdineDAO;
import model.prodotto.ProdottoBean;
import model.utente.UtenteBean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/ProcessOrderServlet")
public class ProcessOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        CarrelloBean carrello = (CarrelloBean) session.getAttribute("carrello");
        if (carrello == null || carrello.getItems() == null || carrello.getItems().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/carrello.jsp");
            return;
        }

        String destinatario = request.getParameter("destinatario");
        String via = request.getParameter("via");
        String citta = request.getParameter("citta");
        String cap = request.getParameter("cap");
        String paymentMethod = request.getParameter("paymentMethod");

        if (destinatario == null || via == null || citta == null || cap == null ||
                destinatario.trim().length() < 2 || via.trim().length() < 2 ||
                citta.trim().length() < 2 || !cap.trim().matches("^\\d{5}$")) {

            request.setAttribute("errorMessage", "Dati di spedizione non validi.");
            request.getRequestDispatcher("/CheckoutServlet").forward(request, response);
            return;
        }

        if ("card".equals(paymentMethod)) {
            String cardName = request.getParameter("cardName");
            String cardNumber = request.getParameter("cardNumber");
            String expiryDate = request.getParameter("expiryDate");
            String cvv = request.getParameter("cvv");

            if (cardName == null || cardNumber == null || expiryDate == null || cvv == null ||
                    cardName.trim().length() < 2 || !cardNumber.trim().matches("^\\d{16}$") ||
                    !expiryDate.trim().matches("^(0[1-9]|1[0-2])/\\d{2}$") || !cvv.trim().matches("^\\d{3}$")) {

                request.setAttribute("errorMessage", "Dati della carta di credito non validi.");
                request.getRequestDispatcher("/CheckoutServlet").forward(request, response);
                return;
            }
        }

        String idUtente = null;
        UtenteBean utenteLoggato = (UtenteBean) session.getAttribute("utente");
        if (utenteLoggato != null) {
            idUtente = utenteLoggato.getEmail();
        }

        String indirizzoCompleto = destinatario.trim() + ", " + via.trim() + ", " + citta.trim() + " (" + cap.trim() + ")";

        try {
            OrdineBean ordine = new OrdineBean();
            ordine.setDataOrdine(new Timestamp(System.currentTimeMillis()));
            ordine.setStatoOrdine("In lavorazione");
            ordine.setCosto(carrello.getPrezzoTotaleComplessivo());
            ordine.setIndirizzo(indirizzoCompleto);
            ordine.setCorriere("Express Delivery");

            long treGiorniInMillisecondi = 3L * 24 * 60 * 60 * 1000;
            ordine.setDataConsegna(new java.sql.Date(System.currentTimeMillis() + treGiorniInMillisecondi));
            ordine.setIdUtente(idUtente);

            Map<ProdottoBean, Integer> prodottiMappati = new HashMap<>();
            for (ItemCarrelloBean item : carrello.getItems()) {
                if (item.getProdotto() != null) {
                    prodottiMappati.put(item.getProdotto(), item.getQuantita());
                }
            }

            OrdineDAO ordineDao = new OrdineDAO();
            ordineDao.doSave(ordine, prodottiMappati);

            session.setAttribute("ultimoNumeroOrdine", ordine.getNumeroOrdine());
            session.removeAttribute("carrello");
            session.setAttribute("cartCount", 0);

            response.sendRedirect(request.getContextPath() + "/confermaOrdine.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Errore nel salvataggio dell'ordine sul database.");
            request.getRequestDispatcher("/CheckoutServlet").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/carrello.jsp");
    }
}