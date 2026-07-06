package control.admin;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import model.prodotto.ProdottoBean;
import model.prodotto.ProdottoDAO;

@WebServlet("/admin/GestioneProdottiServlet")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 25)
public class GestioneProdottiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private String getSourceCopertinePath() {
        String rootPath = getServletContext().getRealPath("");
        File root = new File(rootPath);
        while (root != null && !new File(root, "src").exists() && root.getParentFile() != null) {
            root = root.getParentFile();
        }
        if (root != null && new File(root, "src").exists()) {
            return root.getAbsolutePath() + File.separator + "src" + File.separator + "main" + File.separator + "webapp" + File.separator + "img" + File.separator + "copertine";
        }
        return rootPath + File.separator + "img" + File.separator + "copertine";
    }

    private String getRuntimeCopertinePath() {
        return getServletContext().getRealPath("") + File.separator + "img" + File.separator + "copertine";
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProdottoDAO prodottoDAO = new ProdottoDAO();
        String action = request.getParameter("action");
        String isbn = request.getParameter("isbn");

        try {
            if ("delete".equalsIgnoreCase(action) && isbn != null) {
                prodottoDAO.doDelete(isbn);
                new File(getSourceCopertinePath() + File.separator + isbn + ".jpg").delete();
                new File(getRuntimeCopertinePath() + File.separator + isbn + ".jpg").delete();
                response.sendRedirect(request.getContextPath() + "/admin/GestioneProdottiServlet");
                return;
            }
            else if ("edit".equalsIgnoreCase(action) && isbn != null) {
                ProdottoBean libro = prodottoDAO.doRetrieveByKey(isbn);
                request.setAttribute("libroEdizione", libro);

                List<String> backupImmagini = new ArrayList<>();
                File backupDir = new File(getSourceCopertinePath() + File.separator + "backup");
                if (backupDir.exists() && backupDir.isDirectory()) {
                    String[] files = backupDir.list((dir, name) -> name.startsWith(isbn + "_") && name.endsWith(".jpg"));
                    if (files != null) {
                        backupImmagini = Arrays.asList(files);
                    }
                }

                request.setAttribute("backupImmagini", backupImmagini);
                request.getRequestDispatcher("/admin/form-prodotto-admin.jsp").forward(request, response);
                return;
            }
            else if ("new".equalsIgnoreCase(action)) {
                request.getRequestDispatcher("/admin/form-prodotto-admin.jsp").forward(request, response);
                return;
            }

            List<ProdottoBean> prodotti = prodottoDAO.doRetrieveAll();
            request.setAttribute("prodotti", prodotti);
            request.getRequestDispatcher("/admin/prodotti-admin.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error500.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        ProdottoDAO prodottoDAO = new ProdottoDAO();

        String formAction = request.getParameter("formAction");
        String actionUrl = request.getParameter("action");
        String isbn = request.getParameter("isbn");

        if ("restoreBackup".equalsIgnoreCase(formAction) || "restoreBackup".equalsIgnoreCase(actionUrl)) {
            String nomeFileBackup = request.getParameter("nomeFileBackup");

            if (nomeFileBackup != null && isbn != null && !isbn.trim().isEmpty()) {
                String srcPath = getSourceCopertinePath();
                String runPath = getRuntimeCopertinePath();
                String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
                String backupNome = isbn + "_" + timestamp + ".jpg";

                File srcAttuale = new File(srcPath + File.separator + isbn + ".jpg");
                File srcBackupScelto = new File(srcPath + File.separator + "backup" + File.separator + nomeFileBackup);
                File srcNuovoBackup = new File(srcPath + File.separator + "backup" + File.separator + backupNome);

                File runAttuale = new File(runPath + File.separator + isbn + ".jpg");
                File runBackupScelto = new File(runPath + File.separator + "backup" + File.separator + nomeFileBackup);
                File runNuovoBackup = new File(runPath + File.separator + "backup" + File.separator + backupNome);

                if (srcBackupScelto.exists()) {
                    new File(srcPath + File.separator + "backup").mkdirs();
                    new File(runPath + File.separator + "backup").mkdirs();

                    if (srcAttuale.exists()) {
                        Files.copy(srcAttuale.toPath(), srcNuovoBackup.toPath(), StandardCopyOption.REPLACE_EXISTING);
                    }
                    if (runAttuale.exists()) {
                        Files.copy(runAttuale.toPath(), runNuovoBackup.toPath(), StandardCopyOption.REPLACE_EXISTING);
                    }

                    Files.copy(srcBackupScelto.toPath(), srcAttuale.toPath(), StandardCopyOption.REPLACE_EXISTING);
                    Files.copy(srcBackupScelto.toPath(), runAttuale.toPath(), StandardCopyOption.REPLACE_EXISTING);

                    srcBackupScelto.delete();
                    if (runBackupScelto.exists()) {
                        runBackupScelto.delete();
                    }
                }

                response.sendRedirect(request.getContextPath() + "/admin/GestioneProdottiServlet?action=edit&isbn=" + isbn);
                return;
            }
        }

        String titolo = request.getParameter("titolo");
        String autore = request.getParameter("autore");

        double prezzo = 0.0;
        int disponibilita = 0;

        String prezzoParam = request.getParameter("prezzo");
        if (prezzoParam != null && !prezzoParam.trim().isEmpty()) {
            prezzo = Double.parseDouble(prezzoParam);
        }

        String dispParam = request.getParameter("disponibilita");
        if (dispParam != null && !dispParam.trim().isEmpty()) {
            disponibilita = Integer.parseInt(dispParam);
        }

        String categoria = request.getParameter("categoria");
        String descrizione = request.getParameter("descrizione");

        int iva = 22;
        String idUtentePubblica = "admin@readlyadmin.com";

        ProdottoBean libro = new ProdottoBean(isbn, titolo, autore, prezzo, iva, descrizione, categoria, disponibilita, idUtentePubblica);

        try {
            if ("insert".equalsIgnoreCase(formAction)) {
                if (prodottoDAO.doRetrieveByKey(isbn) != null) {
                    request.setAttribute("errorMessage", "Errore: Esiste già un libro registrato con l'ISBN " + isbn + ". Inserimento annullato.");
                    request.setAttribute("libroEdizione", libro);
                    request.setAttribute("forceAction", "insert");
                    request.getRequestDispatcher("/admin/form-prodotto-admin.jsp").forward(request, response);
                    return;
                }
                prodottoDAO.doSave(libro);
            } else if ("update".equalsIgnoreCase(formAction)) {
                prodottoDAO.doUpdate(libro);
            }

            Part filePart = request.getPart("fotoCopertina");
            if (filePart != null && filePart.getSize() > 0) {
                String srcPath = getSourceCopertinePath();
                String runPath = getRuntimeCopertinePath();

                new File(srcPath).mkdirs();
                new File(runPath).mkdirs();

                File srcAttuale = new File(srcPath + File.separator + isbn + ".jpg");
                File runAttuale = new File(runPath + File.separator + isbn + ".jpg");

                if ("update".equalsIgnoreCase(formAction) && srcAttuale.exists()) {
                    new File(srcPath + File.separator + "backup").mkdirs();
                    new File(runPath + File.separator + "backup").mkdirs();

                    String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
                    String nomeBackup = isbn + "_" + timestamp + ".jpg";

                    Files.copy(srcAttuale.toPath(), new File(srcPath + File.separator + "backup" + File.separator + nomeBackup).toPath(), StandardCopyOption.REPLACE_EXISTING);
                    if (runAttuale.exists()) {
                        Files.copy(runAttuale.toPath(), new File(runPath + File.separator + "backup" + File.separator + nomeBackup).toPath(), StandardCopyOption.REPLACE_EXISTING);
                    }
                }

                try (InputStream inputSrc = filePart.getInputStream()) {
                    Files.copy(inputSrc, new File(srcPath + File.separator + isbn + ".jpg").toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
                try (InputStream inputRun = filePart.getInputStream()) {
                    Files.copy(inputRun, new File(runPath + File.separator + isbn + ".jpg").toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Errore imprevisto del database: " + e.getMessage());
            request.setAttribute("libroEdizione", libro);
            request.getRequestDispatcher("/admin/form-prodotto-admin.jsp").forward(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/GestioneProdottiServlet");
    }
}