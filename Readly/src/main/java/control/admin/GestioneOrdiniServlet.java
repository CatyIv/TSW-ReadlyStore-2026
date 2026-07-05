package control.admin;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.ordine.OrdineBean;
import model.ordine.OrdineDAO;
import model.prodotto.ProdottoBean;

@WebServlet("/admin/GestioneOrdiniServlet")
public class GestioneOrdiniServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public GestioneOrdiniServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        OrdineDAO ordineDAO = new OrdineDAO();
        String action = request.getParameter("action");

        try {
            if ("dettaglio".equalsIgnoreCase(action)) {
                int numeroOrdine = Integer.parseInt(request.getParameter("numeroOrdine"));

                OrdineBean ordine = ordineDAO.doRetrieveByKey(numeroOrdine);
                List<ProdottoBean> prodottiOrdinati = ordineDAO.doRetrieveProdottiByOrdine(numeroOrdine);

                request.setAttribute("ordine", ordine);
                request.setAttribute("prodottiOrdinati", prodottiOrdinati);
                request.getRequestDispatcher("/admin/dettaglio-ordine-admin.jsp").forward(request, response);
                return;
            }

            String filterType = request.getParameter("filterType");
            List<OrdineBean> listaOrdini = null;

            if ("cliente".equalsIgnoreCase(filterType)) {
                String emailCliente = request.getParameter("emailCliente");
                if (emailCliente != null && !emailCliente.trim().isEmpty()) {
                    listaOrdini = ordineDAO.doRetrieveByClienteGlobal(emailCliente.trim());
                }
            }
            else if ("date".equalsIgnoreCase(filterType)) {
                String inizioParam = request.getParameter("dataInizio");
                String fineParam = request.getParameter("dataFine");

                if (inizioParam != null && !inizioParam.isEmpty() && fineParam != null && !fineParam.isEmpty()) {
                    java.sql.Date dataInizio = java.sql.Date.valueOf(inizioParam);
                    java.sql.Date dataFine = java.sql.Date.valueOf(fineParam);
                    listaOrdini = ordineDAO.doRetrieveByDateIntervalGlobal(dataInizio, dataFine);
                }
            }

            if (listaOrdini == null) {
                listaOrdini = ordineDAO.doRetrieveByClienteGlobal("%");
            }

            request.setAttribute("tuttiGliOrdini", listaOrdini);
            request.getRequestDispatcher("/admin/ordini-admin.jsp").forward(request, response);

        } catch (SQLException | IllegalArgumentException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error500.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int numeroOrdine = Integer.parseInt(request.getParameter("numeroOrdine"));
        String nuovoStato = request.getParameter("nuovoStato");

        OrdineDAO ordineDAO = new OrdineDAO();
        try {
            ordineDAO.doUpdateStato(numeroOrdine, nuovoStato);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/GestioneOrdiniServlet");
    }
}