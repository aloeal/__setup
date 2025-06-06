@echo off

:: -- NIST Free Space Optics Terminal Software --  


:: This bat file launches eBUS software for camera/galvo control
:: - @ECHO lines do not print to console, only use rem within loops and :: outside loops for comments

:: NEW Setup: 
:: change PATH_ on line 15 in "" to path where >\FSOTerminal-main\camera_control\cameraprocess is located on PC getting eBUS
:: change PATH_PYTHON on line 20 in "" to path where python executable (python.exe) is located on PC 
:: ________________________________________________________________________________________________________________________________________

:: so pc wont remember variables to enviroment DO NOT REMOVE below line
setlocal enabledelayedexpansion

:: ________________________________________________________________________________________________________________________________________
                %= USER may have to change below! =%

:: path to repo
set "PATH_=C:\OTTRepos\FSOTerminal\"
:: alt path to repo
rem set "PATH_=C:\Users\fcomb\OTTRepos\FSOTerminal\"

:: path to installed python on pc
set "PATH_PYTHON=C:\WPy64-3940\python-3.9.4.amd64\python.exe"
:: alt path to python
rem set "PATH_PYTHON=C:\WinPy3.9.4\WPy64-3940\python-3.9.4.amd64\python.exe" 

:: Above points to the correct location for WinPython 3.9.40 on Spare (and possibly other computers), if this is wrong consider using dev_2024_FSO_startup_altfileloc.bat instead

:: ________________________________________________________________________________________________________________________________________
:: bool if user wants option to debug terminal startup 
set debug=1

:: ________________________________________________________________________________________________________________________________________

echo --------------- Free Space Optics Terminal Software --------------------  
echo NIST: 675.02                                     Last mod: March 12 2025
echo                                                    Allie Christensen                                                          
echo ------------------------------------------------------------------------
echo ________________________________________________________________________
echo.
echo.
:: ________________________________________________________________________________________________________________________________________
            %= skip to fso launch if no debug =%
:askDebug
echo Debug Setup? & set /p answer="Answer (y/n)"

:: when cmd option enabled
if !answer! == y ( echo DEBUG MODE: Setting up cmd prompt... & set debug=1 )

if !answer! neq y (
    echo -n |set /p="meow no^! "
    rem grab other errors
    if !answer! neq n ( echo ERROR askPy: Please input "y" or "n" & goto :askDebug ) 
    
    rem when cmds disabled
    set debug=0
    echo ... meow^! & echo -n | set /p="NORMAL MODE:" 
    )

:: ________________________________________________________________________________________________________________________________________
                %= setup paths needed for installations =% 
:startFSO

:: dynamic path DO NOT CHANGE below
set "SETUP=%PATH_%venv\Scripts\" 
set "WORK_DIR=%PATH_%camera_control\cameraprocess\"

cd %PATH_%

:: ________________________________________________________________________________________________________________________________________
echo                         FSO venv: !SETUP!
echo ________________________________________________________________________
echo.
:: ________________________________________________________________________________________________________________________________________
                %= activate environment and move into working dir =% 
:actVenv

if %debug% ==1 ( echo expect venv dir & echo !SETUP!activate.bat & pause )

:: Ensure virtual environment exists if not create it with local python installed 
if not exist !SETUP!activate.bat ( echo ERROR: Virtual environment not found^! Ensure venvSetup.bat build venv in FSO. & pause && exit /b )

:: Activate the virtual environment
call !SETUP!activate.bat
:: when venv not working allow user to imput cmds 
if %errorlevel% neq 0 ( echo ERROR: Virtual environment activation FAIL^! & cmd /k )

:: ...Change working directory -> where python will work from
cd !WORK_DIR!
echo moved to 
cd

:: ________________________________________________________________________________________________________________________________________

:startBat

:: user wants to debug -> enable cmd /k 
if %debug% neq 0 ( 
    echo debuggin^^! 
    cmd /k && python camera_processor_V2.py
)
if %debug% == 0 ( 
    echo mode & pause 
    python camera_processor_V2.py 
)

:: Check if Python inside the venv exists
if %errorlevel% neq 0 (
    echo ERROR: FSO startup!
    if %debug% neq 0 ( echo debuggin^^! & cmd /k ) else ( exit /b )
	)


:: ________________________________________________________________________________________________________________________________________

endlocal
deactivate

