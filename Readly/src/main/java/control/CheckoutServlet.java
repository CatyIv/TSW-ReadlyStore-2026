package control;

import model.carrello.CarrelloBean;
import model.itemcarrello.ItemCarrelloBean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        CarrelloBean carrelloUtente = (CarrelloBean) session.getAttribute("carrello");

        Collection<ItemCarrelloBean> collezioneItems = carrelloUtente.getItems();
        List<ItemCarrelloBean> elementiCarrello = new ArrayList<>(collezioneItems);
        double totaleCarrello = carrelloUtente.getPrezzoTotaleComplessivo();

        request.setAttribute("elementiCarrello", elementiCarrello);
        request.setAttribute("totaleCarrello", totaleCarrello);

        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}