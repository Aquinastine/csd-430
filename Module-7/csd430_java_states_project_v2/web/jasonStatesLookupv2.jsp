<%@ page import="java.util.Map,java.util.LinkedHashMap,beans.JasonStatesBean" %>
<jsp:useBean id="statesBean" class="beans.JasonStatesBean" scope="page" />
<%
    // Variables used by the page.
    String message = "";
    LinkedHashMap<Integer, String> options = new LinkedHashMap<Integer, String>();
    Map<String, String> selectedRecord = null;
    String selectedIdText = request.getParameter("stateId");
    String action = request.getParameter("action");
    boolean showTableCard = false;

    // Handle create, populate, and drop commands.
    if (action != null) {
        if ("create".equals(action)) {
            message = statesBean.createTable();
        } else if ("populate".equals(action)) {
            message = statesBean.populateTable();
        } else if ("drop".equals(action)) {
            message = statesBean.dropTable();
        } else if ("insert".equals(action)) {
            String stateName = request.getParameter("stateName");
            String abbreviation = request.getParameter("abbreviation");
            String capitalCity = request.getParameter("capitalCity");
            String region = request.getParameter("region");
            String statehoodYearText = request.getParameter("statehoodYear");

            try {
                int statehoodYear = Integer.parseInt(statehoodYearText);

                message = statesBean.insertState(
                        stateName,
                        abbreviation,
                        capitalCity,
                        region,
                        statehoodYear
                );

                showTableCard = true;

            } catch (NumberFormatException e) {
                message = "Insert failed: Statehood year must be a valid number.";
            }
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
    <link rel="stylesheet" href="css/LuttrellMatrixStyles.css">
</head>
<script>
    function toggleInsertCard() {
        const card = document.getElementById("insertStateCard");

        if (card.style.display === "none" || card.style.display === "") {
            card.style.display = "block";
        } else {
            card.style.display = "none";
        }
    }
</script>


<body>
    <div class="matrix-rain"></div>
    <div class="page-wrapper">

        <!-- Header card contains action buttons and content description -->
        <div class="card">
            <div class="course-name">CSD-430 Server Side Development</div>
            <h1 class="title">Module 7 Assignment - JavaBean Database Lookup</h1>
            <p class="subtitle">Jason States Data</p>
            <p>
            This JSP page uses a JavaBean and JDBC to manage, read and update data from the
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
                <button type="button" onclick="toggleInsertCard()">Add New State Record</button>
            </div>

            <% if (message != null && message.length() > 0) { %>
                <div class="message"><%= message %></div>
            <% } %>
        </div>

        <!-- Normally Hidden Data Entry Form. Is unhidded when the Add New Stat Record button is used -->
        <div class="card hidden-card" id="insertStateCard">
            <h2>Add a New State Record</h2>
            <p class="muted">
                Enter the state data below. The state ID key will be created automatically by the database.
            </p>

            <form method="post" action="jasonStatesLookup.jsp">
                <input type="hidden" name="action" value="insert">

                <div class="form-row">
                    <label for="stateName">State Name:</label>
                    <input type="text" id="stateName" name="stateName" required>
                </div>

                <div class="form-row">
                    <label for="abbreviation">Abbreviation:</label>
                    <input type="text" id="abbreviation" name="abbreviation" maxlength="2" required>
                </div>

                <div class="form-row">
                    <label for="capitalCity">Capital City:</label>
                    <input type="text" id="capitalCity" name="capitalCity" required>
                </div>

                <div class="form-row">
                    <label for="region">Region:</label>
                    <input type="text" id="region" name="region" required>
                </div>

                <div class="form-row">
                    <label for="statehoodYear">Statehood Year:</label>
                    <input type="number" id="statehoodYear" name="statehoodYear" required>
                </div>

                <button type="submit">Insert State Record</button>
            </form>
        </div>
        
        <!-- Normally hidden table results card, is unhidden with the add data button. -->
         <% if (showTableCard) { %>
        <div class="card">
            <h2>All State Records</h2>

            <table>
                <thead>
                    <tr>
                        <th>State ID</th>
                        <th>State Name</th>
                        <th>Abbreviation</th>
                        <th>Capital City</th>
                        <th>Region</th>
                        <th>Statehood Year</th>
                    </tr>
                </thead>

                <tbody>
                    <%
                        java.util.List<Map<String, String>> allStates = statesBean.getAllStates();

                        if (allStates.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="6">No records are currently available.</td>
                        </tr>
                    <%
                        } else {
                            for (Map<String, String> state : allStates) {
                    %>
                        <tr>
                            <td><%= state.get("State ID") %></td>
                            <td><%= state.get("State Name") %></td>
                            <td><%= state.get("Abbreviation") %></td>
                            <td><%= state.get("Capital City") %></td>
                            <td><%= state.get("Region") %></td>
                            <td><%= state.get("Statehood Year") %></td>
                        </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
        <% } %>

        <!-- Single Record Lookup card -->
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
        <!-- Footer Card content description -->
        <div class="card">
            <h1 class="subtitle">Module 7 Assignment - JavaBean Database Lookup</h1>
            <p class="footer-name">Jason Luttrell</p>
            <p class="footer-date">April 27, 2026</p>
        </div>
    </div>
</body>
</html>
