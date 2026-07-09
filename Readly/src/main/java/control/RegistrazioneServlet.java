package control;

import model.utente.UtenteBean;
import model.utente.UtenteDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

@WebServlet("/RegistrazioneServlet")
public class RegistrazioneServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[\\w!#$%&'*+/=?`{|}~^-]+(?:\\.[\\w!#$%&'*+/=?`{|}~^-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,6}$");
    private static final Pattern TELEFONO_PATTERN = Pattern.compile("^\\+\\d{1,13}$");

    private static final java.util.logging.Logger logger = java.util.logging.Logger.getLogger(RegistrazioneServlet.class.getName());

    public RegistrazioneServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<String> errorMessages = new ArrayList<>();

        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String email = request.getParameter("email");
        String telefono = request.getParameter("telefono");
        String password = request.getParameter("password");
        String confermaPassword = request.getParameter("confermaPassword");

        if (nome == null || nome.trim().isEmpty()) {
            errorMessages.add("Campo obbligatorio.");
        }

        if (cognome == null || cognome.trim().isEmpty()) {
            errorMessages.add("Campo obbligatorio.");
        }

        if (email == null || email.trim().isEmpty()) {
            errorMessages.add("Email non valida.");
        } else if(!EMAIL_PATTERN.matcher(email).matches()) {
            errorMessages.add("Formato email non valido.");
        }

        if (telefono == null || telefono.trim().isEmpty()) {
            errorMessages.add("Campo obbligatorio.");
        } else if(!TELEFONO_PATTERN.matcher(telefono).matches()) {
            errorMessages.add("il numero di telefono deve contenere il prefisso e 10 cifre.");
        }

        if (password == null || password.trim().isEmpty()) {
            errorMessages.add("Campo obbligatorio.");
        } else if(password.length() < 8) {
            errorMessages.add("la password deve contenere almeno 8 caratteri.");
        } else if(!password.equals(confermaPassword)) {
            errorMessages.add("Le password non corrispondono.");
        }

        UtenteDAO utenteDAO = new UtenteDAO();

        if (errorMessages.isEmpty()) {
            try {
                if (utenteDAO.doRetrieveByKey(email) != null){
                    errorMessages.add("Email già esistente.");
                }
            } catch (SQLException e) {
                System.err.println("Errore SQL durante il controllo unicità email: " + e.getMessage());
                errorMessages.add("Errore interno del server.");
            }
        }

        if (!errorMessages.isEmpty()) {
            request.setAttribute("errorMessage", String.join("<br>", errorMessages));
            request.getRequestDispatcher("registrazione.jsp").forward(request, response);
            return;
        }

        try {
            UtenteBean nuovoUtente = new UtenteBean();
            nuovoUtente.setNome(nome);
            nuovoUtente.setCognome(cognome);
            nuovoUtente.setEmail(email);
            nuovoUtente.setTelefono(telefono);

            String hashedPassword = Security.hashPassword(password);
            nuovoUtente.setPassword(hashedPassword);

            nuovoUtente.setAdmin(false);

            utenteDAO.doSave(nuovoUtente);
            String success = "Registrazione avvenuta con successo!";
            response.sendRedirect(request.getContextPath() + "/LoginServlet?email=" + email + "&success=" + success);

        } catch (SQLException e) {
            logger.log(java.util.logging.Level.SEVERE, "Errore SQL durante la registrazione", e);
            request.setAttribute("errorMessage", "Si è verificato un errore durante la registrazione. Riprova più tardi.");
            request.getRequestDispatcher("registrazione.jsp").forward(request, response);
        }
    }
}