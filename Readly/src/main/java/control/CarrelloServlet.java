package control;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import model.carrello.CarrelloBean;
import model.carrello.CarrelloDAO;
import model.itemcarrello.ItemCarrelloDAO;
import model.prodotto.ProdottoBean;
import model.prodotto.ProdottoDAO;
import model.utente.UtenteBean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.lang.reflect.Type;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/CarrelloServlet")
public class CarrelloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final CarrelloDAO carrelloDao = new CarrelloDAO();
    private final ItemCarrelloDAO itemCarrelloDao = new ItemCarrelloDAO();
    private final ProdottoDAO prodottoDao = new ProdottoDAO();
    private Gson gson;

    public CarrelloServlet() {
        super();
    }

    @Override
    public void init() throws ServletException {
        super.init();
        gson = new Gson();
    }

    @SuppressWarnings({"CallToPrintStackTrace", "override"})
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UtenteBean utenteLoggato = (UtenteBean) session.getAttribute("user");

        CarrelloBean carrello = (CarrelloBean) session.getAttribute("carrello");
        if (carrello == null) {
            carrello = new CarrelloBean();
        }

        try {
            if (utenteLoggato != null) {
                CarrelloBean carrelloDb = carrelloDao.doRetrieveByUtente(utenteLoggato.getEmail());
                if (carrelloDb != null) {
                    carrello = carrelloDb;
                }
            } else {
                carrello.svuotaCarrello();
                Map<String, Integer> guestCartData = getGuestCartFromCookies(request);
                for (Map.Entry<String, Integer> entry : guestCartData.entrySet()) {
                    ProdottoBean prodotto = prodottoDao.doRetrieveByKey(entry.getKey());
                    if (prodotto != null) {
                        carrello.aggiungiProdotto(prodotto, entry.getValue());
                    }
                }
            }

            session.setAttribute("carrello", carrello);

            int conteggioBadge = (carrello.getItems() != null) ? carrello.getItems().size() : 0;
            session.setAttribute("cartCount", conteggioBadge);

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

        HttpSession session = request.getSession();
        UtenteBean utenteLoggato = (UtenteBean) session.getAttribute("user");

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

                        if (utenteLoggato != null && carrello.getIdCarrello() != null) {
                            itemCarrelloDao.doSave(carrello.getIdCarrello(), isbn, qta);
                        } else {
                            Map<String, Integer> guestCart = getGuestCartFromCookies(request);
                            guestCart.put(isbn, guestCart.getOrDefault(isbn, 0) + qta);
                            saveGuestCartToCookies(response, guestCart);
                        }
                    }
                }

                else if (action.equalsIgnoreCase("modifica")) {
                    int nuovaQta = Integer.parseInt(request.getParameter("quantita"));

                    carrello.modificaQuantita(isbn, nuovaQta);

                    if (utenteLoggato != null && carrello.getIdCarrello() != null) {
                        if (nuovaQta <= 0) {
                            itemCarrelloDao.doDelete(carrello.getIdCarrello(), isbn);
                        } else {
                            itemCarrelloDao.doUpdate(carrello.getIdCarrello(), isbn, nuovaQta);
                        }
                    } else {
                        Map<String, Integer> guestCart = getGuestCartFromCookies(request);
                        if (nuovaQta <= 0) {
                            guestCart.remove(isbn);
                        } else {
                            guestCart.put(isbn, nuovaQta);
                        }
                        saveGuestCartToCookies(response, guestCart);
                    }
                }

                else if (action.equalsIgnoreCase("rimuovi")) {
                    carrello.rimuoviProdotto(isbn);

                    if (utenteLoggato != null && carrello.getIdCarrello() != null) {
                        itemCarrelloDao.doDelete(carrello.getIdCarrello(), isbn);
                    } else {
                        Map<String, Integer> guestCart = getGuestCartFromCookies(request);
                        guestCart.remove(isbn);
                        saveGuestCartToCookies(response, guestCart);
                    }
                }

                else if (action.equalsIgnoreCase("svuota")) {
                    carrello.svuotaCarrello();

                    if (utenteLoggato != null && carrello.getIdCarrello() != null) {
                        carrelloDao.doClear(carrello.getIdCarrello());
                    } else {
                        Cookie cookie = new Cookie("guest_cart", "");
                        cookie.setMaxAge(0);
                        cookie.setPath("/");
                        response.addCookie(cookie);
                    }
                }
            }

            int conteggioBadge = (carrello.getItems() != null) ? carrello.getItems().size() : 0;
            session.setAttribute("cartCount", conteggioBadge);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
            return;
        }

        response.sendRedirect("carrello.jsp");
    }


    private Map<String, Integer> getGuestCartFromCookies(HttpServletRequest request) {
        Map<String, Integer> guestCart = new HashMap<>();
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("guest_cart".equals(cookie.getName())) {
                    try {
                        String cartJsonString = URLDecoder.decode(cookie.getValue(), StandardCharsets.UTF_8.toString());
                        Type type = new TypeToken<Map<String, Integer>>() {}.getType();
                        guestCart = gson.fromJson(cartJsonString, type);
                        if (guestCart == null) {
                            guestCart = new HashMap<>();
                        }
                    } catch (Exception ignored) {
                    }
                    break;
                }
            }
        }
        return guestCart;
    }

    private void saveGuestCartToCookies(HttpServletResponse response, Map<String, Integer> guestCart) {
        try {
            String cartJsonString = gson.toJson(guestCart);
            Cookie cookie = new Cookie("guest_cart", URLEncoder.encode(cartJsonString, StandardCharsets.UTF_8.toString()));
            cookie.setMaxAge(7 * 24 * 60 * 60);
            cookie.setPath("/");
            response.addCookie(cookie);
        } catch (Exception ignored) {
        }
    }


    public static void mergeGuestCartToUserCart(HttpServletRequest request, HttpServletResponse response, UtenteBean utenteLoggato) throws SQLException {
        CarrelloDAO cDao = new CarrelloDAO();
        ItemCarrelloDAO iDao = new ItemCarrelloDAO();
        ProdottoDAO pDao = new ProdottoDAO();
        Gson staticGson = new Gson();

        Map<String, Integer> guestCart = new HashMap<>();
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("guest_cart".equals(cookie.getName())) {
                    try {
                        String cartJsonString = URLDecoder.decode(cookie.getValue(), StandardCharsets.UTF_8.toString());
                        Type type = new TypeToken<Map<String, Integer>>() {}.getType();
                        guestCart = staticGson.fromJson(cartJsonString, type);
                    } catch (Exception ignored) {
                    }
                    break;
                }
            }
        }

        if (guestCart != null && !guestCart.isEmpty()) {
            CarrelloBean userCarrello = cDao.doRetrieveByUtente(utenteLoggato.getEmail());
            if (userCarrello != null && userCarrello.getIdCarrello() != null) {
                for (Map.Entry<String, Integer> entry : guestCart.entrySet()) {
                    String isbn = entry.getKey();
                    int qtaGuest = entry.getValue();

                    ProdottoBean prodotto = pDao.doRetrieveByKey(isbn);
                    if (prodotto != null) {
                        // Utilizza la tua doSave reale che gestisce autonomamente l'ON DUPLICATE KEY UPDATE!
                        iDao.doSave(userCarrello.getIdCarrello(), isbn, qtaGuest);
                    }
                }
            }

            Cookie cookie = new Cookie("guest_cart", "");
            cookie.setMaxAge(0);
            cookie.setPath("/");
            response.addCookie(cookie);
        }
    }
}