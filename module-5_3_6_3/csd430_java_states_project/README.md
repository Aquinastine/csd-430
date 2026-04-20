# CSD430 JavaBean + JSP States Project

This package matches your established project schema and data exactly:
- Database: `CSD430`
- User: `student1`
- Password: `pass`
- Table: `jason_states_data`

## Files
- `src/beans/JasonStatesBean.java` - JavaBean source for create, populate, drop, dropdown loading, and single-record lookup
- `web/jasonStatesLookup.jsp` - JSP page using scriptlets for Java code and HTML outside the scriptlets
- `web/WEB-INF/web.xml` - simple deployment descriptor
- `sql/01_setup_csd430_permissions.sql` - database/user/grant setup
- `sql/02_jason_states_data_reference.sql` - reference SQL using your exact table structure and insert data

## Table structure used everywhere
```sql
CREATE TABLE jason_states_data (
    state_id INT AUTO_INCREMENT PRIMARY KEY,
    state_name VARCHAR(50) NOT NULL,
    abbreviation CHAR(2) NOT NULL,
    capital_city VARCHAR(50) NOT NULL,
    region VARCHAR(30) NOT NULL,
    statehood_year INT NOT NULL
);
```

## Suggested Tomcat layout
```text
YourApp/
  jasonStatesLookup.jsp
  WEB-INF/
    web.xml
    classes/
      beans/
        JasonStatesBean.class
    lib/
      mysql-connector-j-9.6.0.jar
```

## Compile the bean on Windows
After placing the MySQL Connector/J JAR in `web\WEB-INF\lib`:

```bat
mkdir web\WEB-INF\classes
javac -cp ".;web\WEB-INF\lib\mysql-connector-j-9.6.0.jar" -d web\WEB-INF\classes src\beans\JasonStatesBean.java
```

## Run order
1. Run `sql/01_setup_csd430_permissions.sql`.
2. Copy the web app files into your Tomcat webapp folder.
3. Put the MySQL Connector/J JAR in `WEB-INF\lib`.
4. Compile `JasonStatesBean.java` into `WEB-INF\classes`.
5. Start Tomcat.
6. Open `http://localhost:8080/YourApp/jasonStatesLookup.jsp`.
7. Click **Create Table**.
8. Click **Populate Table**.
9. Choose a state ID from the dropdown and click **Display Record**.

## Notes
- The JavaBean uses JDBC and the MySQL Connector/J driver.
- The JavaBean creates, populates, drops, and reads the same table name your instructor will use.
- The dropdown is built from all `state_id` key values currently in the table.
- The selected record is displayed in an HTML table with the headings in the `thead` section.
