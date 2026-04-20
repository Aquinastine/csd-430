package beans;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * JasonStatesBean
 *
 * JavaBean used by the JSP page to:
 * 1) connect to the CSD430 database
 * 2) create the jason_states_data table
 * 3) populate the table with sample records
 * 4) drop the table
 * 5) return key values for the HTML dropdown
 * 6) return one selected record for table display
 */
public class JasonStatesBean implements Serializable {
    private static final long serialVersionUID = 1L;

    // Database connection settings for the assignment.
    private static final String DB_URL =
            "jdbc:mysql://localhost:3306/CSD430?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DB_USER = "student1";
    private static final String DB_PASSWORD = "pass";
    private static final String TABLE_NAME = "jason_states_data";

    // Load the MySQL JDBC driver one time when the class is first used.
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found. Add mysql-connector-j to WEB-INF/lib.", e);
        }
    }

    /**
     * Open a JDBC connection using the assignment account.
     */
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    /**
     * Create the assignment table if it does not already exist.
     * Table structure matches the project SQL exactly.
     */
    public String createTable() {
        String sql = "CREATE TABLE IF NOT EXISTS " + TABLE_NAME + " ("
                + "state_id INT AUTO_INCREMENT PRIMARY KEY, "
                + "state_name VARCHAR(50) NOT NULL, "
                + "abbreviation CHAR(2) NOT NULL, "
                + "capital_city VARCHAR(50) NOT NULL, "
                + "region VARCHAR(30) NOT NULL, "
                + "statehood_year INT NOT NULL"
                + ")";

        try (Connection conn = getConnection(); Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(sql);
            return "Table '" + TABLE_NAME + "' is ready.";
        } catch (SQLException e) {
            return "Create table failed: " + e.getMessage();
        }
    }

    /**
     * Insert the 10 state records used for the project.
     * This method avoids duplicate inserts by checking whether records already exist.
     */
    public String populateTable() {
        createTable();

        if (getRecordCount() > 0) {
            return "Table '" + TABLE_NAME + "' already contains records. Drop it first if you want to reload the sample data.";
        }

        String sql = "INSERT INTO " + TABLE_NAME
                + " (state_name, abbreviation, capital_city, region, statehood_year) "
                + "VALUES (?, ?, ?, ?, ?)";

        Object[][] data = {
                {"Alabama", "AL", "Montgomery", "South", 1819},
                {"Alaska", "AK", "Juneau", "West", 1959},
                {"Arizona", "AZ", "Phoenix", "West", 1912},
                {"California", "CA", "Sacramento", "West", 1850},
                {"Colorado", "CO", "Denver", "West", 1876},
                {"Connecticut", "CT", "Hartford", "Northeast", 1788},
                {"Florida", "FL", "Tallahassee", "South", 1845},
                {"New York", "NY", "Albany", "Northeast", 1788},
                {"Texas", "TX", "Austin", "South", 1845},
                {"Virginia", "VA", "Richmond", "South", 1788}
        };

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            for (Object[] row : data) {
                ps.setString(1, (String) row[0]);
                ps.setString(2, (String) row[1]);
                ps.setString(3, (String) row[2]);
                ps.setString(4, (String) row[3]);
                ps.setInt(5, (Integer) row[4]);
                ps.addBatch();
            }
            ps.executeBatch();
            return "Sample data loaded into '" + TABLE_NAME + "'.";
        } catch (SQLException e) {
            return "Populate table failed: " + e.getMessage();
        }
    }

    /**
     * Drop the assignment table.
     */
    public String dropTable() {
        String sql = "DROP TABLE IF EXISTS " + TABLE_NAME;

        try (Connection conn = getConnection(); Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(sql);
            return "Table '" + TABLE_NAME + "' was dropped.";
        } catch (SQLException e) {
            return "Drop table failed: " + e.getMessage();
        }
    }

    /**
     * Check whether the table currently exists.
     */
    public boolean tableExists() {
        try (Connection conn = getConnection()) {
            DatabaseMetaData meta = conn.getMetaData();
            try (ResultSet rs = meta.getTables(null, null, TABLE_NAME, new String[] {"TABLE"})) {
                return rs.next();
            }
        } catch (SQLException e) {
            return false;
        }
    }

    /**
     * Return all key values for the dropdown.
     * Key = state_id, Label = state_id + state_name + abbreviation.
     */
    public LinkedHashMap<Integer, String> getStateOptions() {
        LinkedHashMap<Integer, String> options = new LinkedHashMap<Integer, String>();
        String sql = "SELECT state_id, state_name, abbreviation FROM " + TABLE_NAME + " ORDER BY state_id";

        if (!tableExists()) {
            return options;
        }

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                int id = rs.getInt("state_id");
                String label = id + " - " + rs.getString("state_name") + " (" + rs.getString("abbreviation") + ")";
                options.put(id, label);
            }
        } catch (SQLException e) {
            // Return any options collected so far; JSP can still render safely.
        }
        return options;
    }

    /**
     * Return the selected record as a map so the JSP can display it in a table.
     */
    public Map<String, String> getStateById(int stateId) {
        LinkedHashMap<String, String> record = new LinkedHashMap<String, String>();
        String sql = "SELECT state_id, state_name, abbreviation, capital_city, region, statehood_year "
                + "FROM " + TABLE_NAME + " WHERE state_id = ?";

        if (!tableExists()) {
            return record;
        }

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, stateId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    record.put("State ID", String.valueOf(rs.getInt("state_id")));
                    record.put("State Name", rs.getString("state_name"));
                    record.put("Abbreviation", rs.getString("abbreviation"));
                    record.put("Capital City", rs.getString("capital_city"));
                    record.put("Region", rs.getString("region"));
                    record.put("Statehood Year", String.valueOf(rs.getInt("statehood_year")));
                }
            }
        } catch (SQLException e) {
            record.put("Error", e.getMessage());
        }
        return record;
    }

    /**
     * Return the number of records currently in the table.
     */
    public int getRecordCount() {
        String sql = "SELECT COUNT(*) FROM " + TABLE_NAME;

        if (!tableExists()) {
            return 0;
        }

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            return 0;
        }
        return 0;
    }
}
