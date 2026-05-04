@echo off
setlocal

REM =====================================================
REM Jason Luttrell
REM CSD 430
REM Build and deploy helper for the States JSP/JavaBean app
REM =====================================================

REM Change these two paths to match your machine.
set "TOMCAT_WEBAPP=C:\java\apache-tomcat-11.0.20\webapps\luttrell_5_3"
set "MYSQL_JAR=C:\Users\Luttr\csd\csd-430\module-5_3_6_3\csd430_java_states_project\web\WEB-INF\lib\mysql-connector-j-9.6.0"

REM Project root = folder where this BAT file lives, one level up.
set "PROJECT_ROOT=%~dp0.."

if not exist "%MYSQL_JAR%" (
    echo ERROR: MySQL Connector/J jar not found.
    echo Update MYSQL_JAR in this BAT file first.
    goto :eof
)

if not exist "%TOMCAT_WEBAPP%" (
    echo Creating Tomcat webapp folder...
    mkdir "%TOMCAT_WEBAPP%"
)

if not exist "%TOMCAT_WEBAPP%\WEB-INF" mkdir "%TOMCAT_WEBAPP%\WEB-INF"
if not exist "%TOMCAT_WEBAPP%\WEB-INF\classes" mkdir "%TOMCAT_WEBAPP%\WEB-INF\classes"
if not exist "%TOMCAT_WEBAPP%\WEB-INF\lib" mkdir "%TOMCAT_WEBAPP%\WEB-INF\lib"

copy /Y "%PROJECT_ROOT%\web\jasonStatesLookup.jsp" "%TOMCAT_WEBAPP%\jasonStatesLookup.jsp" >nul
copy /Y "%PROJECT_ROOT%\web\WEB-INF\web.xml" "%TOMCAT_WEBAPP%\WEB-INF\web.xml" >nul
copy /Y "%MYSQL_JAR%" "%TOMCAT_WEBAPP%\WEB-INF\lib\" >nul

javac -cp "%MYSQL_JAR%" -d "%TOMCAT_WEBAPP%\WEB-INF\classes" "%PROJECT_ROOT%\src\beans\JasonStatesBean.java"
if errorlevel 1 (
    echo.
    echo ERROR: javac failed.
    goto :eof
)

echo.
echo Build and deployment complete.
echo Open this URL after Tomcat is running:
echo http://localhost:8080/luttrell_5_3/
echo.
echo Then use the JSP buttons to Create Table, Populate Table, and Display a Record.
endlocal
