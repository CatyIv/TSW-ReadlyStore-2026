<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrazione - Readly</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/stylesheets/auth.css">
</head>
<body>

<div class="auth-container">
    <div class="auth-logo">Readly</div>
    <div class="auth-subtitle">Crea il tuo account in pochi secondi</div>

    <c:if test="${not empty errorMessages}">
        <div class="global-error">
                ${errorMessages}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/RegistrazioneServlet" method="POST" id="regForm">

        <div class="form-group">
            <label for="nome">Nome</label>
            <input type="text" id="nome" name="nome"
                   placeholder="Mario" required autocomplete="given-name"
                   value="${param.cognome}">
        </div>

        <div class="form-group">
            <label for="cognome">Cognome</label>
            <input type="text" id="cognome" name="cognome"
                   placeholder="Rossi" required autocomplete="family-name"
                   value="${param.cognome}">
        </div>

        <div class="form-group">
            <label for="email">Indirizzo Email</label>
            <input type="email" id="email" name="email"
                   placeholder="email@example.com" required autocomplete="email"
                   value="${param.email}">
            <span id="emailError" class="error-message"></span>
        </div>

        <div class="form-group">
            <label for="telefono">Numero di Telefono</label>
            <input type="tel" id="telefono" name="telefono"
                   placeholder="+393331234567" required maxlength="13"
                   value="${param.telefono}">
            <span id="telefonoError" class="error-message"></span>
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password"
                   placeholder="Almeno 8 caratteri" required>
            <span id="passwordError" class="error-message"></span>
        </div>

        <div class="form-group">
            <label for="confermaPassword">Conferma Password</label>
            <input type="password" id="confermaPassword" name="confermaPassword"
                   placeholder="Conferma la password" required>
            <span id="confermaPasswordError" class="error-message"></span>
        </div>

        <button type="submit" class="btn-auth">Registrati</button>
    </form>

    <div class="auth-footer">
        Hai già un account? <a href="${pageContext.request.contextPath}/login.jsp">Accedi</a>
    </div>
</div>

</body>
</html>