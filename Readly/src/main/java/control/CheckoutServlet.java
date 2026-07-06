package control;

import model.carrello.CarrelloBean;
import model.itemcarrello.ItemCarrelloBean;
import model.immagine.ImmagineBean;
import model.immagine.ImmagineDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        CarrelloBean carrelloUtente = (CarrelloBean) session.getAttribute("carrello");

        List<ItemCarrelloBean> elementiCarrello = new ArrayList<>();
        double totaleCarrello = 0.0;

        if (carrelloUtente != null && carrelloUtente.getItems() != null) {
            Collection<ItemCarrelloBean> collezioneItems = carrelloUtente.getItems();
            elementiCarrello = new ArrayList<>(collezioneItems);
            totaleCarrello = carrelloUtente.getPrezzoTotaleComplessivo();
        }

        int totaleCopie = 0;
        for (ItemCarrelloBean item : elementiCarrello) {
            totaleCopie += item.getQuantita();
        }

        double imponibile = totaleCarrello / 1.22;
        double quotaIva = totaleCarrello - imponibile;

        Map<String, String> mappeImmagini = new HashMap<>();
        ImmagineDAO immagineDao = new ImmagineDAO();

        for (ItemCarrelloBean item : elementiCarrello) {
            if (item.getProdotto() != null) {
                String isbn = item.getProdotto().getIsbn();
                String nomeFileImmagine = "no-cover.png";
                try {
                    List<ImmagineBean> listaImmagini = immagineDao.doRetrieveByProdotto(isbn);
                    if (listaImmagini != null && !listaImmagini.isEmpty()) {
                        nomeFileImmagine = listaImmagini.get(0).getUrl();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                mappeImmagini.put(isbn, nomeFileImmagine);
            }
        }

        request.setAttribute("elementiCarrello", elementiCarrello);
        request.setAttribute("totaleCarrello", totaleCarrello);
        request.setAttribute("totaleCopie", totaleCopie);
        request.setAttribute("imponibile", imponibile);
        request.setAttribute("quotaIva", quotaIva);
        request.setAttribute("mappeImmagini", mappeImmagini);

        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}