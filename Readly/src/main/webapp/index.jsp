<html>
<body>
<h2><%= "Hello World!" %></h2>
</body>
</html>
<% response.sendRedirect(request.getContextPath() + "/DettaglioProdottoServlet?isbn=9780000000001"); %>