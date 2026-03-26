<%@ page import="java.util.Date" %>

<%--
Jason Luttrell
CSD430-T301
Module 1.3
3/22/26
--%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>JSP Demo - Module 1.3</title>

    <link rel="stylesheet" href="css/LuttrellStyles.css">
</head>

<body>

<div class="card">

    <h1>JSP Dynamic Page Example</h1>

    <p>This page demonstrates a working JSP file with embedded Java code and HTML.</p>

    <div class="section">
        <h3>Server-Side Java Output</h3>

        <div class="data">
            <% 
                String user = "Jason";
                Date currentDate = new Date();
            %>

            <p><strong>User:</strong> <%= user %></p>
            <p><strong>Current Date:</strong> <%= currentDate %></p>
        </div>
    </div>

    <div class="section">
        <h3>Simple Calculation (Java in JSP)</h3>

        <div class="data">
            <% 
                int a = 10;
                int b = 5;
                int sum = a + b;
            %>

            <p><%= a %> + <%= b %> = <strong><%= sum %></strong></p>
        </div>
    </div>

    <div class="footer">
        JSP + Java + HTML successfully integrated &#10004;
    </div>

</div>

</body>
</html>