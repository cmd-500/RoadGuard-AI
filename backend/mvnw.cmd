@echo off
:: -----------------------------------------------------------------------------
:: Maven Wrapper Script for Windows
:: -----------------------------------------------------------------------------

setlocal enabledelayedexpansion

:: Resolve the base directory
set "BASEDIR=%~dp0"
if "%BASEDIR:~-1%"=="\" set "BASEDIR=%BASEDIR:~0,-1%"

:: Locate the wrapper jar
set "WRAPPER_JAR=%BASEDIR%\.mvn\wrapper\maven-wrapper.jar"
if not exist "%WRAPPER_JAR%" (
  echo ERROR: %WRAPPER_JAR% not found. Run 'mvn wrapper:wrapper' to generate it.
  exit /b 1
)

:: Determine the java command
if not "%JAVA_HOME%"=="" (
  if exist "%JAVA_HOME%\jre\bin\java.exe" (
    set "JAVACMD=%JAVA_HOME%\jre\bin\java.exe"
  ) else if exist "%JAVA_HOME%\bin\java.exe" (
    set "JAVACMD=%JAVA_HOME%\bin\java.exe"
  ) else (
    echo ERROR: JAVA_HOME is set to an invalid directory: %JAVA_HOME%
    exit /b 1
  )
) else (
  set "JAVACMD=java"
  where java >nul 2>nul || (
    echo ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.
    exit /b 1
  )
)

:: Execute the wrapper
"%JAVACMD%" -Dmaven.multiModuleProjectDirectory="%BASEDIR%" -jar "%WRAPPER_JAR%" %*