# CSD430 States Project - Luttrell 5.3 - Tomcat Windows Deployment

## Recommended source folder
Keep your editable project here:

`C:\Users\Luttr\csd\csd-430\module-5\luttrell_5_3`

You do **not** need to edit files directly inside Tomcat except for deployed output.

## Recommended Tomcat webapp name
Use this Tomcat application folder name:

`luttrell_5_3`

That gives you this URL:

`http://localhost:8080/luttrell_5_3/`

## Tomcat deployment layout
Put the deployed app here:

`C:\java\apache-tomcat-11.0.20\webapps\luttrell_5_3\`

With this structure:

```text
luttrell_5_3
|-- jasonStatesLookup.jsp
`-- WEB-INF
    |-- web.xml
    |-- classes
    |   `-- beans
    |       `-- JasonStatesBean.class
    `-- lib
        `-- mysql-connector-j-9.3.0.jar
```

## One-time database setup
Run this SQL first in phpMyAdmin or MySQL:

- `sql/01_setup_csd430_permissions.sql`

This creates:
- database: `CSD430`
- user: `student1`
- password: `pass`
- grants on `CSD430.*`

## Compile and deploy manually
Open Command Prompt in your source project folder and run:

```bat
mkdir "C:\java\apache-tomcat-11.0.20\webapps\luttrell_5_3\WEB-INF\classes\beans"
mkdir "C:\java\apache-tomcat-11.0.20\webapps\luttrell_5_3\WEB-INF\lib"
copy web\jasonStatesLookup.jsp "C:\java\apache-tomcat-11.0.20\webapps\luttrell_5_3\jasonStatesLookup.jsp"
copy web\WEB-INF\web.xml "C:\java\apache-tomcat-11.0.20\webapps\luttrell_5_3\WEB-INF\web.xml"
copy "C:\path\to\mysql-connector-j-9.3.0.jar" "C:\java\apache-tomcat-11.0.20\webapps\luttrell_5_3\WEB-INF\lib\"
javac -cp "C:\path\to\mysql-connector-j-9.3.0.jar" -d "C:\java\apache-tomcat-11.0.20\webapps\luttrell_5_3\WEB-INF\classes" src\beans\JasonStatesBean.java
```

## Faster option
Edit the two paths in:

`deploy\build_and_deploy_windows.bat`

Then run that BAT file.

## Run order in the browser
1. Start Tomcat.
2. Browse to `http://localhost:8080/luttrell_5_3/`
3. Click **Create Table**.
4. Click **Populate Table**.
5. Choose a key from the dropdown.
6. Click **Display Record**.

## Notes
- The JavaBean connects with the same credentials required by your assignment.
- The JSP uses scriptlets and keeps HTML outside the Java blocks.
- The dropdown is built from the key field `state_id`.
- The selected row is displayed in an HTML table with headers in the `thead`.
