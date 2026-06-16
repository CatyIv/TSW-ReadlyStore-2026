package control;

import model.prodotto.ProdottoBean;
import model.prodotto.ProdottoDAO;
import model.utente.UtenteBean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/CatalogoServlet")
public class CatalogoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ProdottoDAO prodottoDAO;
    private static final int ITEMS_PER_PAGE = 9;

    @Override
    public void init() throws ServletException {
        super.init();
        prodottoDAO = new ProdottoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UtenteBean loggedUser = (UtenteBean) session.getAttribute("utente");

        try {
            session.setAttribute("cartCount", CarrelloServlet.getCartItemCount(request, loggedUser != null ? loggedUser.getEmail() : null));
        } catch (SQLException e) {
            session.setAttribute("cartCount", 0);
        }

        String message = request.getParameter("message");
        if (message != null && !message.isEmpty()) {
            request.setAttribute("message", URLDecoder.decode(message, StandardCharsets.UTF_8.toString()));
        }
        String errorMessageParam = request.getParameter("errorMessage");
        if (errorMessageParam != null && !errorMessageParam.isEmpty()) {
            request.setAttribute("errorMessage", URLDecoder.decode(errorMessageParam, StandardCharsets.UTF_8.toString()));
        }

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) action = "filter";

        String searchQuery = request.getParameter("searchQuery");
        if (searchQuery != null && searchQuery.isEmpty()) searchQuery = null;

        String category = request.getParameter("category");
        if (category != null && category.isEmpty()) category = null;

        Float minPrice = null;
        String minPriceStr = request.getParameter("minPrice");
        if (minPriceStr != null && !minPriceStr.isEmpty()) {
            try { minPrice = Float.parseFloat(minPriceStr); } catch (NumberFormatException e) { minPrice = null; }
        }

        Float maxPrice = null;
        String maxPriceStr = request.getParameter("maxPrice");
        if (maxPriceStr != null && !maxPriceStr.isEmpty()) {
            try { maxPrice = Float.parseFloat(maxPriceStr); } catch (NumberFormatException e) { maxPrice = null; }
        }

        String sortBy = request.getParameter("sortBy");

        int currentPage = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try { currentPage = Integer.parseInt(pageStr); } catch (NumberFormatException e) { currentPage = 1; }
        }

        try {
            List<ProdottoBean> allProducts = prodottoDAO.doRetrieveAll();

            final String finalCategory = category;
            final Float finalMinPrice = minPrice;
            final Float finalMaxPrice = maxPrice;
            final String finalSearch = searchQuery != null ? searchQuery.toLowerCase() : null;

            List<ProdottoBean> filteredProducts = allProducts.stream()
                    .filter(p -> finalCategory == null || finalCategory.equals(p.getCategoria()))
                    .filter(p -> finalMinPrice == null || p.getPrezzo() >= finalMinPrice)
                    .filter(p -> finalMaxPrice == null || p.getPrezzo() <= finalMaxPrice)
                    .filter(p -> finalSearch == null ||
                            p.getTitolo().toLowerCase().contains(finalSearch) ||
                            p.getAutore().toLowerCase().contains(finalSearch) ||
                            p.getIsbn().contains(finalSearch))
                    .collect(Collectors.toList());

            // 6. ORDINAMENTO IN MEMORIA
            if ("priceAsc".equals(sortBy)) {
                filteredProducts.sort(Comparator.comparingDouble(ProdottoBean::getPrezzo));
            } else if ("priceDesc".equals(sortBy)) {
                filteredProducts.sort(Comparator.comparingDouble(ProdottoBean::getPrezzo).reversed());
            } else {
                filteredProducts.sort(Comparator.comparing(ProdottoBean::getTitolo)); // Default Alfabetico
            }

            int totalProducts = filteredProducts.size();
            int totalPages = (int) Math.ceil((double) totalProducts / ITEMS_PER_PAGE);
            if (totalPages == 0) totalPages = 1;

            if (currentPage < 1) currentPage = 1;
            if (currentPage > totalPages) currentPage = totalPages;

            int fromIndex = (currentPage - 1) * ITEMS_PER_PAGE;
            int toIndex = Math.min(fromIndex + ITEMS_PER_PAGE, totalProducts);

            List<ProdottoBean> pageProducts = new ArrayList<>();
            if (totalProducts > 0 && fromIndex < totalProducts) {
                pageProducts = filteredProducts.subList(fromIndex, toIndex);
            }

            request.setAttribute("products", pageProducts);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("filterCategory", category);
            request.setAttribute("filterMinPrice", minPrice != null ? String.valueOf(minPrice) : "");
            request.setAttribute("filterMaxPrice", maxPrice != null ? String.valueOf(maxPrice) : "");
            request.setAttribute("filterSortBy", sortBy);
            request.setAttribute("searchQuery", searchQuery);

        } catch (SQLException e) {
            System.err.println("Errore nel catalogo: " + e.getMessage());
            request.setAttribute("errorMessage", "Errore nel caricamento del catalogo.");
        }

        request.getRequestDispatcher("/catalogo.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}