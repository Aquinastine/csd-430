<%@ page import="java.util.Map,java.util.LinkedHashMap,beans.JasonStatesBean" %>
<jsp:useBean id="statesBean" class="beans.JasonStatesBean" scope="page" />
<%
    // Variables used by the page.
    String message = "";
    LinkedHashMap<Integer, String> options = new LinkedHashMap<Integer, String>();
    Map<String, String> selectedRecord = null;
    String selectedIdText = request.getParameter("stateId");
    String action = request.getParameter("action");

    // Handle create, populate, and drop commands.
    if (action != null) {
        if ("create".equals(action)) {
            message = statesBean.createTable();
        } else if ("populate".equals(action)) {
            message = statesBean.populateTable();
        } else if ("drop".equals(action)) {
            message = statesBean.dropTable();
        }
    }

    // Load dropdown options after any requested action completes.
    options = statesBean.getStateOptions();

    // If the user selected a key value, fetch the matching record.
    if (selectedIdText != null && selectedIdText.trim().length() > 0) {
        try {
            int selectedId = Integer.parseInt(selectedIdText);
            selectedRecord = statesBean.getStateById(selectedId);
        } catch (NumberFormatException e) {
            message = "Invalid key value selected.";
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CSD430 - States Database Lookup</title>
    <style>
        body {
            font-family: Arial, Helvetica, sans-serif;
            background: #f4f6f8;
            margin: 0;
            padding: 24px;
            color: #1f2933;
        }
        .card {
            max-width: 900px;
            margin: 0 auto 20px auto;
            background: #ffffff;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }
        h1, h2 {
            margin-top: 0;
        }
        .button-row form {
            display: inline-block;
            margin-right: 10px;
            margin-bottom: 10px;
        }
        button {
            padding: 10px 14px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            background: #0b5ed7;
            color: white;
            font-weight: bold;
        }
        button.danger {
            background: #b02a37;
        }
        select {
            min-width: 320px;
            padding: 8px;
            margin-right: 10px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        thead th {
            text-align: left;
            background: #e9ecef;
            padding: 12px;
            border: 1px solid #ced4da;
        }
        tbody td {
            padding: 12px;
            border: 1px solid #ced4da;
        }
        .message {
            padding: 12px;
            background: #eef4ff;
            border-left: 4px solid #0b5ed7;
            margin-top: 10px;
        }
        .muted {
            color: #5c6770;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>CSD430 States Database</h1>
        <p>
            This JSP page uses a JavaBean and JDBC to manage and read data from the
            <strong>jason_states_data</strong> table in the <strong>CSD430</strong> database.
        </p>
        <p class="muted">
            The table contains six fields: state ID, state name, abbreviation, capital city, region, and statehood year.
        </p>

        <div class="button-row">
            <form method="post" action="jasonStatesLookup.jsp">
                <input type="hidden" name="action" value="create">
                <button type="submit">Create Table</button>
            </form>

            <form method="post" action="jasonStatesLookup.jsp">
                <input type="hidden" name="action" value="populate">
                <button type="submit">Populate Table</button>
            </form>

            <form method="post" action="jasonStatesLookup.jsp">
                <input type="hidden" name="action" value="drop">
                <button type="submit" class="danger">Drop Table</button>
            </form>
        </div>

        <% if (message != null && message.length() > 0) { %>
            <div class="message"><%= message %></div>
        <% } %>
    </div>

    <div class="card">
        <h2>Lookup a Single Record by Key</h2>
        <p class="muted">
            Current record count: <strong><%= statesBean.getRecordCount() %></strong>
        </p>

        <% if (options.size() == 0) { %>
            <p>No key values are available yet. Create and populate the table first.</p>
        <% } else { %>
            <form method="get" action="jasonStatesLookup.jsp">
                <label for="stateId"><strong>Select a State Key:</strong></label><br><br>
                <select name="stateId" id="stateId">
                    <option value="">-- Choose a key value --</option>
                    <% for (Map.Entry<Integer, String> entry : options.entrySet()) { %>
                        <option value="<%= entry.getKey() %>"
                            <%= String.valueOf(entry.getKey()).equals(selectedIdText) ? "selected" : "" %>>
                            <%= entry.getValue() %>
                        </option>
                    <% } %>
                </select>
                <button type="submit">Display Record</button>
            </form>
        <% } %>
    </div>

    <% if (selectedRecord != null && selectedRecord.size() > 0) { %>
        <div class="card">
            <h2>Selected State Record</h2>
            <p class="muted">The selected state record is displayed below in table format.</p>
            <table>
                <thead>
                    <tr>
                        <% for (String fieldName : selectedRecord.keySet()) { %>
                            <th><%= fieldName %></th>
                        <% } %>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <% for (String fieldValue : selectedRecord.values()) { %>
                            <td><%= fieldValue %></td>
                        <% } %>
                    </tr>
                </tbody>
            </table>
        </div>
    <% } %>
</body>
</html>
