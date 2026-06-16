package control;

import model.prodotto.ProdottoBean;
import model.prodotto.ProdottoDAO;
import model.utente.UtenteBean;
import model.wishlist.WishlistBean;
import model.wishlist.WishlistDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/WishlistServlet")
public class WishlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final WishlistDAO WishlistDao = new WishlistDAO();
    private final ProdottoDAO ProdottoDao = new ProdottoDAO();

    public WishlistServlet() {
        super();
    }

    /**
     * Mostra la pagina dei segnalibri (wishlist) dell'utente loggato
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UtenteBean utenteLoggato = (UtenteBean) session.getAttribute("utente");

        // Controllo se l'utente è autenticato
        if (utenteLoggato == null) {
            request.setAttribute("errorMessage", "Accedi per visualizzare e gestire i tuoi segnalibri.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            // 1. Recupera i record grezzi dei segnalibri associati alla mail dell'utente
            List<WishlistBean> wishlistRighe = WishlistDao.doRetrieveByUtente(utenteLoggato.getEmail());

            // 2. Idrata la lista ottenendo i dettagli reali del catalogo (ProdottoBean) tramite l'ISBN
            List<ProdottoBean> prodottiWishlist = new ArrayList<>();

            for (WishlistBean item : wishlistRighe) {
                ProdottoBean prodotto = ProdottoDao.doRetrieveByKey(item.getIsbnProdotto());
                if (prodotto != null) {
                    prodottiWishlist.add(prodotto);
                }
            }

            // 3. Inietta la lista di prodotti idratata nella richiesta per la JSP
            request.setAttribute("prodottiWishlist", prodottiWishlist);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
            return;
        }

        // Inoltra alla pagina di visualizzazione
        request.getRequestDispatcher("/wishlist.jsp").forward(request, response);
    }

    /**
     * Gestisce le operazioni POST: aggiunta, rimozione singola e svuotamento completo
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UtenteBean utenteLoggato = (UtenteBean) session.getAttribute("utente");

        // Protezione: blocca le modifiche se l'utente non è loggato
        if (utenteLoggato == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String isbn = request.getParameter("isbn");
        String emailUtente = utenteLoggato.getEmail();

        try {
            if (action != null) {

                // AZIONE: AGGIUNGI UN LIBRO AI SEGNALIBRI
                if (action.equalsIgnoreCase("aggiungi")) {
                    if (isbn != null && !isbn.trim().isEmpty()) {

                        // Verifichiamo che il prodotto esista effettivamente a catalogo
                        ProdottoBean prodotto = ProdottoDao.doRetrieveByKey(isbn);

                        if (prodotto != null) {
                            // Impediamo duplicati per non scatenare eccezioni di chiave primaria nel DB
                            List<WishlistBean> wishlistAttuale = WishlistDao.doRetrieveByUtente(emailUtente);
                            boolean giaPresente = wishlistAttuale.stream()
                                    .anyMatch(item -> item.getIsbnProdotto().equals(isbn));

                            if (!giaPresente) {
                                WishlistBean nuovaEntry = new WishlistBean();
                                nuovaEntry.setIdUtente(emailUtente);
                                nuovaEntry.setIsbnProdotto(isbn);
                                nuovaEntry.setDataAggiunta(new Timestamp(System.currentTimeMillis()));

                                WishlistDao.doSave(nuovaEntry);
                            }
                        }
                    }
                }

                // AZIONE: RIMUOVI UN SINGOLO SEGNALIBRO
                else if (action.equalsIgnoreCase("rimuovi")) {
                    if (isbn != null && !isbn.trim().isEmpty()) {
                        WishlistDao.doDelete(emailUtente, isbn);
                    }
                }

                // AZIONE: SVUOTA TUTTI I SEGNALIBRI DELL'UTENTE
                else if (action.equalsIgnoreCase("svuota")) {
                    List<WishlistBean> lista = WishlistDao.doRetrieveByUtente(emailUtente);
                    for (WishlistBean item : lista) {
                        WishlistDao.doDelete(emailUtente, item.getIsbnProdotto());
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
            return;
        }

        // PRG Pattern (Post/Redirect/Get): Evita il reinvio del form ricaricando la pagina
        response.sendRedirect(request.getContextPath() + "/WishlistServlet");
    }
}