package control;

import java.io.IOException;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(LogoutServlet.class.getName());

    public LogoutServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session != null) {
            String utenteEmail = "Ospite";
            Object utenteObj = session.getAttribute("utente");

            if (utenteObj != null) {
                try {
                    java.lang.reflect.Method getEmailMethod = utenteObj.getClass().getMethod("getEmail");
                    utenteEmail = (String) getEmailMethod.invoke(utenteObj);
                } catch (Exception e) {
                    utenteEmail = "Utente Registrato";
                }
            }

            session.invalidate();
            logger.info("Logout eseguito con successo per: " + utenteEmail);
        }

        response.sendRedirect(request.getContextPath() + "/CatalogoServlet");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}