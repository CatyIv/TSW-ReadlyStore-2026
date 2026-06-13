<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.prodotto.ProdottoBean" %>
<%@ page import="model.immagine.ImmagineBean" %>
<%@ page import="java.util.List" %>

<% ProdottoBean libro = (ProdottoBean) request.getAttribute("libro");
List<ImmagineBean> listaImmagini = (List<ImmagineBean>) request.getAttribute("listaImmagine");
String immaginePrincipale = (String) request.getAttribute("immaginePrincipale");

if(libro == null){
    request.setAttribute("messaggioErrore", "Accesso non valido alla pagina del prodotto.");
    request.getRequestDispatcher("/erroreProdotto.jsp").forward(request,response);
}
<!DOCTYPE html>
    <html lang="it">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <title><%= libro.getTitolo() %> - Readly</title>
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/img/small_logo.png">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/stylesheets/DettaglioProdotto.css">
    </head>

 <jsp:include page="header.jsp" />