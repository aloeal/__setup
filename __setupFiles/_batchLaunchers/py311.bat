:: ________________________________________________________________________________________________________________________________________

		%= Ensure script runs as administrator and setup preferred batch file startup necessities ( no ENV changes ) =%

:setupShell

@echo off
echo Elevating privileges...

:: check if admin shell if not open one and close current shell
net session >nul 2>&1 
if %errorlevel% neq 0 ( powershell -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs -WindowStyle Normal" && exit /b ) 

setlocal enabledelayedexpansion

:: ________________________________________________________________________________________________________________________________________

		%= get to venv, activate and enable user command =%

:loadVenv

echo madi 
cd "C:\py311\"
pause 
 

call "C:\py311\Scripts\activate.bat" 
if %errorlevel% neq 0 ( echo ERROR activating venv & pause) else ( echo Ther ya go you beaut^! ) 
cmd /k 