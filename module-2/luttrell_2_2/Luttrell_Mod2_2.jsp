<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.io.*, java.nio.file.*, org.json.*" %>

<%-- assignment info
Jason Luttrell
CSD430-T301
Module 2.2 - JSP Scriptlets
3/23/26
--%>


<%! // Import necessary classes for JSON handling and file I/O
    // Define a class to represent the country ratings (one line of data)
    public static class CountryRating {
        String country;
        int cuisine;
        int history;
        int cost;

        public CountryRating(String country, int cuisine, int history, int cost) {
            this.country = country;
            this.cuisine = cuisine;
            this.history = history;
            this.cost = cost;
        }
    }

    // Helper method to load country ratings from the JSON file
    public List<CountryRating> loadCountries(String filePath) throws Exception {
        List<CountryRating> countries = new ArrayList<>();

        String jsonText = new String(Files.readAllBytes(Paths.get(filePath)));
        JSONArray jsonArray = new JSONArray(jsonText);

        for (int i = 0; i < jsonArray.length(); i++) {
            JSONObject obj = jsonArray.getJSONObject(i);
            countries.add(new CountryRating(
                obj.getString("country"),
                obj.getInt("cuisine"),
                obj.getInt("history"),
                obj.getInt("cost")
            ));
        }

        return countries;
    }

    // Helper method to save a new country rating to the JSON file
    public void saveCountry(String filePath, CountryRating newCountry) throws Exception {
        String jsonText = new String(Files.readAllBytes(Paths.get(filePath)));
        JSONArray jsonArray = new JSONArray(jsonText);

        JSONObject obj = new JSONObject();
        obj.put("country", newCountry.country);
        obj.put("cuisine", newCountry.cuisine);
        obj.put("history", newCountry.history);
        obj.put("cost", newCountry.cost);

        jsonArray.put(obj);

        Files.write(Paths.get(filePath), jsonArray.toString(2).getBytes());
    }
%>

<% // Load the country ratings from the JSON file and handle form 
   // submission if it's a POST request
    List<CountryRating> countries = new ArrayList<>();
    String message = null;

    try {
        String filePath = application.getRealPath("LuttrellCountryData.json");

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String country = request.getParameter("country");
            String cuisineParam = request.getParameter("cuisine");
            String historyParam = request.getParameter("history");
            String costParam = request.getParameter("cost");

            if (country != null && cuisineParam != null && historyParam != null && costParam != null) {
                int cuisine = Integer.parseInt(cuisineParam);
                int history = Integer.parseInt(historyParam);
                int cost = Integer.parseInt(costParam);

                CountryRating newCountry = new CountryRating(country, cuisine, history, cost);
                saveCountry(filePath, newCountry);

                response.sendRedirect("Luttrell_Mod2_2.jsp");
                return;
            }
        }

        countries = loadCountries(filePath);

    } catch (Exception e) {
        message = "Error processing request: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Module 2 Assignment - JSP Scriptlets</title>
    <link rel="stylesheet" href="css/LuttrellMatrixStyles.css">
</head>
<body>
    <div class="matrix-rain"></div>

    <!-- This Div is for the header information. 
         It will display the course name, assignment title, and a subtitle. -->
    <div class="page-wrapper">
        <div class="card">
            <div class="course-name">CSD-430 Server Side Development
            </div>
            <h1 class="title">Module 2 Assignment - JSP Scriptlets</h1>
            <p class="subtitle">Countries Visited</p>
        </div>

        <!-- This Div is for the table that displays the country ratings. 
         We will use JSP scriptlets to loop through the list of countries 
         and display them in the table. -->
        <div class="card">
            <table>
                <thead>
                    <tr>
                        <th>Country</th>
                        <th>Cuisine</th>
                        <th>History</th>
                        <th>Cost of Visiting</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (CountryRating item : countries) {
                    %>
                    <tr>
                        <td><%= item.country %></td>
                        <td class="stars">
                            <%
                                for (int i = 1; i <= 5; i++) {
                                    if (i <= item.cuisine) {
                            %>
                                <span class="filled">★</span>
                            <%
                                    } else {
                            %>
                                <span class="empty">☆</span>
                            <%
                                    }
                                }
                            %>
                        </td>
                        <td class="stars">
                            <%
                                for (int i = 1; i <= 5; i++) {
                                    if (i <= item.history) {
                            %>
                                <span class="filled">★</span>
                            <%
                                    } else {
                            %>
                                <span class="empty">☆</span>
                            <%
                                    }
                                }
                            %>
                        </td>
                        <td class="dollars">
                            <%
                                for (int i = 1; i <= 5; i++) {
                                    if (i <= item.cost) {
                            %>
                                <span class="dollar-filled">$</span>
                            <%
                                    } else {
                            %>
                                <span class="dollar-empty">$</span>
                            <%
                                    }
                                }
                            %>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        

            <div class="note">
                Cuisine and History are rated with stars. Cost of Visiting is rated with dollar signs.
            </div>
        </div>
        
        <!-- This Div is for the form to add a new country rating. 
         It will submit to the same page (index.jsp) and we will handle 
         the form submission in the JSP scriptlet at the top of the page. -->
        <div class="card">
            <h2 class="section-title">Add a Country</h2>
            <form method="post" action="Luttrell_Mod2_2.jsp">
                <div class="form-row">
                    <label for="country">Country</label>
                    <input type="text" id="country" name="country" required>
                </div>

                <div class="form-row">
                    <label for="cuisine">Cuisine Rating (0-5)</label>
                    <div class="radio-group">
                        <label><input type="radio" name="cuisine" value="0" required> 0</label>
                        <label><input type="radio" name="cuisine" value="1"> 1</label>
                        <label><input type="radio" name="cuisine" value="2"> 2</label>
                        <label><input type="radio" name="cuisine" value="3"> 3</label>
                        <label><input type="radio" name="cuisine" value="4"> 4</label>
                        <label><input type="radio" name="cuisine" value="5"> 5</label>
                    </div>
                </div>

                <div class="form-row">
                    <label for="history">History Rating (0-5)</label>
                    <div class="radio-group">
                        <label><input type="radio" name="history" value="0" required> 0</label>
                        <label><input type="radio" name="history" value="1"> 1</label>
                        <label><input type="radio" name="history" value="2"> 2</label>
                        <label><input type="radio" name="history" value="3"> 3</label>
                        <label><input type="radio" name="history" value="4"> 4</label>
                        <label><input type="radio" name="history" value="5"> 5</label>
                    </div>
                </div>

                <div class="form-row">
                    <label for="cost">Cost Rating (0-5)</label>
                    <div class="radio-group">
                        <label><input type="radio" name="cost" value="0" required> 0</label>
                        <label><input type="radio" name="cost" value="1"> 1</label>
                        <label><input type="radio" name="cost" value="2"> 2</label>
                        <label><input type="radio" name="cost" value="3"> 3</label>
                        <label><input type="radio" name="cost" value="4"> 4</label>
                        <label><input type="radio" name="cost" value="5"> 5</label>
                    </div>
                </div>

                <div class="controls">
                    <button type="submit">Add Country</button>
                </div>
            </form>
        </div>

        <!-- This Div is for displaying any messages (like errors) to the user. 
         We will set the message variable in the JSP scriptlet at the 
         top of the page if there is an error. -->
        <% if (message != null) { %>
            <div class="card">
                <p><%= message %></p>
            </div>
        <% } %>

        <!-- This Div is for the footer information. 
         It will display the student's name and the date. -->
        <div class="card">
            <h1 class="subtitle">Module 2 Assignment - JSP Scriptlets</h1>
            <p class="footer-name">Jason Luttrell</p>
            <p class="footer-date">March 23, 2026</p>
        </div>
    </div>
</body>
</html>