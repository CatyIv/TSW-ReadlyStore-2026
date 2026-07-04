package control;

import model.prodotto.ProdottoBean;
import model.prodotto.ProdottoDAO;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String query = request.getParameter("search");

        List<ProdottoBean> risultati = new ArrayList<>();
        ProdottoDAO dao = new ProdottoDAO();

        if (query != null && !query.trim().isEmpty()) {
            try {
                risultati = dao.doRetrieveBySearch(query);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < risultati.size(); i++) {
            ProdottoBean p = risultati.get(i);
            json.append("{")
                    .append("\"isbn\":\"").append(p.getIsbn()).append("\",")
                    .append("\"titolo\":\"").append(p.getTitolo().replace("\"", "\\\"")).append("\"")
                    .append("}");
            if (i < risultati.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");

        PrintWriter out = response.getWriter();
        out.print(json.toString());
        out.flush();
    }
}