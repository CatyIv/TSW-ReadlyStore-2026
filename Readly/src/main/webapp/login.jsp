<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accedi - Readly</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/stylesheets/auth.css">
</head>
<body>

<div class="auth-container">
    <div class="auth-logo">Readly</div>
    <div class="auth-subtitle">Accedi per gestire i tuoi libri ed ordini</div>

    <c:if test="${not empty param.success}">
        <div class="global-success" style="color: #155724; background-color: #d4edda; border-color: #c3e6cb; padding: 10px; margin-bottom: 15px; border-radius: 4px; text-align: center;">
            <c:out value="${param.success}"/>
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="global-error">
            <c:out value="${error}"/>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/LoginServlet" method="POST">

        <div class="form-group">
            <label for="email">Indirizzo Email</label>
            <input type="email" id="email" name="email"
                   placeholder="esempio@mail.it" required autocomplete="email"
                   value="${param.email}">
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password"
                   placeholder="Inserisci la tua password" required>
        </div>

        <button type="submit" class="btn-auth">Accedi</button>
    </form>

    <div class="auth-footer">
        Non hai un account? <a href="${pageContext.request.contextPath}/registrazione.jsp">Registrati qui</a>
    </div>
</div>

</body>
</html>