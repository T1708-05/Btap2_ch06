<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Murach's Java Servlets and JSP</title>
  <link rel="stylesheet" href="styles/main.css" type="text/css">
</head>

<body>
  <h1>Thanks for taking our survey!</h1>

  <p>Here is the information that you entered:</p>

  <label>Email:</label>
  <span>${user.email}</span><br>

  <label>First Name:</label>
  <span>${user.firstName}</span><br>

  <label>Last Name:</label>
  <span>${user.lastName}</span><br>

  <label>Heard From:</label>
  <span>${user.heardFrom}</span><br>

  <label>Updates:</label>
  <span>${user.wantsUpdates}</span><br>

  <c:if test="${user.wantsUpdates == 'Yes'}">
    <label>Contact Via:</label>
    <span>${user.contactVia}</span><br>
  </c:if>
</body>
</html>
