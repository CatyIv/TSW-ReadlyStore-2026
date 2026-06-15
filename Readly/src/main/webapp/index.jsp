<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<body>
<h2><%= "Hello World!" %></h2>
</body>
<% response.sendRedirect(request.getContextPath() + "/DettaglioProdottoServlet?isbn=9780000000001"); %>
</html>
