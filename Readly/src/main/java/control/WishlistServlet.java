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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UtenteBean utenteLoggato = (UtenteBean) session.getAttribute("utente");

        if (utenteLoggato == null) {
            request.setAttribute("errorMessage", "Accedi per visualizzare e gestire i tuoi segnalibri.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            List<WishlistBean> wishlistRighe = WishlistDao.doRetrieveByUtente(utenteLoggato.getEmail());

            List<ProdottoBean> prodottiWishlist = new ArrayList<>();

            for (WishlistBean item : wishlistRighe) {
                ProdottoBean prodotto = ProdottoDao.doRetrieveByKey(item.getIsbnProdotto());
                if (prodotto != null) {
                    prodottiWishlist.add(prodotto);
                }
            }

            request.setAttribute("prodottiWishlist", prodottiWishlist);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
            return;
        }

        request.getRequestDispatcher("/wishlist.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UtenteBean utenteLoggato = (UtenteBean) session.getAttribute("utente");

        String isAjax = request.getParameter("ajax");

        if (utenteLoggato == null) {
            if ("true".equalsIgnoreCase(isAjax)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Non autenticato\"}");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String isbn = request.getParameter("isbn");
        String emailUtente = utenteLoggato.getEmail();

        try {
            if (action != null) {

                if (action.equalsIgnoreCase("aggiungi")) {
                    if (isbn != null && !isbn.trim().isEmpty()) {
                        ProdottoBean prodotto = ProdottoDao.doRetrieveByKey(isbn);

                        if (prodotto != null) {
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
                } else if (action.equalsIgnoreCase("rimuovi")) {
                    if (isbn != null && !isbn.trim().isEmpty()) {
                        WishlistDao.doDelete(emailUtente, isbn);
                    }
                    if ("true".equalsIgnoreCase(isAjax)) {
                        response.setContentType("application/json");
                        response.setCharacterEncoding("UTF-8");
                        response.getWriter().write("{\"status\":\"success\",\"action\":\"rimuovi\",\"isbn\":\"" + isbn + "\"}");
                        return;
                    }
                } else if (action.equalsIgnoreCase("svuota")) {
                    List<WishlistBean> lista = WishlistDao.doRetrieveByUtente(emailUtente);
                    for (WishlistBean item : lista) {
                        WishlistDao.doDelete(emailUtente, item.getIsbnProdotto());
                    }
                    if ("true".equalsIgnoreCase(isAjax)) {
                        response.setContentType("application/json");
                        response.setCharacterEncoding("UTF-8");
                        response.getWriter().write("{\"status\":\"success\",\"action\":\"svuota\"}");
                        return;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            if ("true".equalsIgnoreCase(isAjax)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Errore database\"}");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/error.jsp");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/WishlistServlet");
    }
}