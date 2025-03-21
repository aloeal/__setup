@echo off
:: Batch file to setup virtual environment given:
:: -> python is installed at PATH_PYTHON
:: -> && a requirements.txt is provided at PATH_

:: ________________________________________________________________________________________________________________________________________

:: Ensure script runs as administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Elevating privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs -WindowStyle Normal" && exit /b
)

@echo off

:: so pc wont remember variables to enviroment
setlocal enabledelayedexpansion

set allie=1
:: ________________________________________________________________________________________________________________________________________
                    %= USER may have to change below! =%
:: path to repo

:: expedite path setting on
if !allie! ==1 ( set "PATH_=C:\Users\anc32\GitItUp\FSOTerminal-local\" & set "PATH_PYTHON=C:\Program Files\Python39\python.exe" & goto :done )

:: nuc1
set "PATH_=C:\OTTRepos\FSOTerminal\"

:: alt path to repo, baldur?
rem set "PATH_=C:\Users\fcomb\OTTRepos\FSOTerminal\"

:: path to installed python on pc
N
:: nuc1
set "PATH_PYTHON=C:\WPy64-3940\python-3.9.4.amd64\python.exe"

:: alt path to python baldur?
rem set "PATH_PYTHON=C:\WinPy3.9.4\WPy64-3940\python-3.9.4.amd64\python.exe"

:done
echo ... & pause

:: Above points to the correct location for WinPython 3.9.40 on Spare (and possibly other computers), if this is wrong consider using dev_2024_FSO_startup_altfileloc.bat instead

:: ________________________________________________________________________________________________________________________________________
:: bool if user wants option to debug terminal startup or change installs
set ask=0
:: if python already installed on pc
set skipPython=0

:: do not change below


:: bools if user wants to install git bash and executables in exe.tar
set skipVenv=0
set skipExe=0
set skipGit=0

set closetime=10
set dots=1
set debug=0

:: ________________________________________________________________________________________________________________________________________

echo _____________________________ FSO venv non-auto setup ________________________________
echo NIST: 675.02                                                   Last mod: March 12 2025
echo Written by: Allie Christensen ^& Thea Triano
echo _______________________________________________________________________________________
echo            File sets up a virutal environment given:
echo                - Directory with setup files exes, requirement.txt, etc.
echo                - Directory with Python for the install
echo                - Gitbash and exe.7z are installed by DEFUALT...
echo                    ...adjust exeBool and gitBool
echo        ________________________________________________________________________
echo _______________________________________________________________________________________
echo.
echo   VENV  --------------------------------------------
echo.
echo Working DIR: -default       ^> %PATH_%
echo python DIR:  -default       ^> !PATH_PYTHON!
echo --------------------------------------------
echo.
echo READY
echo.
echo -n | set /p="-----> "

:: ________________________________________________________________________________________________________________________________________
            %= all user input if not debug =%
:askDebug
:: ask for use input of fast setup

if %ask% ==0 (
    echo FAST MODE: & echo --------------------------------------------
    goto :askPyType )

echo DEBUG setup mode or change paths? & set /p answer=" Answer (y/n): "

:: when cmd option enabled
if /i !answer! == y ( echo DEBUG MODE: & echo -------------------------------------------- )

if /i !answer! neq y (
    echo -n | set /p=meow no^! ...meow
    rem grab other errors
    if /i !answer! neq n ( echo. & echo ERROR askPy: Please input "y" or "n" & echo Please try again^. & goto :askDebug )

    rem when cmds disabled, note default of debug = false == 0
    echo NORMAL MODE:  & goto :askPyType )

:: ________________________________________________________________________________________________________________________________________
:: _______________________________________________________
:: _______________________________________________________
:: note below ask labels only performed when debug ==1
:: _______________________________________________________
:: _______________________________________________________
:: ________________________________________________________________________________________________________________________________________





:askPy

:: as user which python dir
echo Install python? & echo -n | set /p answer=" Answer (y/n): "

:: when changing path option enabled
if /i !answer! == y ( echo lets get all pythons setups & set skipPython = 0 & set skipVenv=0 )

if /i !answer! neq y (
    echo -n |set /p=ummm....
    rem grab other errors
    if /i !answer! neq n ( echo. & echo ERROR askPY: Please input "y" or "n" & echo Please try again^. & goto :askPy )
    if /i !answer! == n ( echo -n | set /p="... yas! no snakes on this GD terminal !" & set skipPython = 1 & set skipVenv=0 ) )

:: _______________________________________________________

echo jub & pause
:: _______________________________________________________
:: _______________________________________________________

:: Ask user for Python type (WinPython or Python)

:askPyType

echo Select Python type: WinPython or Python
set /p pyType=" Answer (WinPython/Python, w/p is also fine): "
set "pyType=!pyType!"

:: Validate input
if /i "!pyType!" neq "WinPython" & if /i "!pyType!" neq "Python" & if /i "!pyType!:~0,2" neq "py" & if /i "!pyType!:~0,3" neq "win" (
    goto :resultTrue ) else ( goto :resultFalse )

:resultFalse
REM do something for a false result
echo.
echo ERROR: Invalid input. Please enter "WinPython" or "Python".
echo Please try again. & pause
goto :askPyType

:resultTrue
REM do something for a true result
echo jub & pause


:: _______________________________________________________

:askVersion
:: Ask user for version

echo Enter the version you want to install (e.g., 3.10.9):
set /p pyVersion=" Version: "

:: Validate version format (basic numeric check)
echo !pyVersion! | findstr /r "^[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$" >nul
if %errorlevel% neq 0 (
    echo.
    echo ERROR: Invalid version format. Use a format like 3.10.9.
    echo Please try again.
    goto :askVersion
)

echo.
echo Selected Python Type: !pyType!
echo Selected Version: !pyVersion!

if %debug% ==0 ( echo faster... & goto :)

:: Continue with further script logic...
:: _______________________________________________________
:: _______________________________________________________
        %= skip to venv setup if no changing of defaults =%
:askChange
::ask for a change of default paths for install/setup

echo -n | set /p=Change default paths (see above)? & echo -n | set /p answer=" Answer (y/n): "

:: when changing path option enabled
if /i !answer! == y ( echo. & echo okie dokie articokie...change it up^! & goto :askPath )

if /i !answer! neq y (
    echo -n |set /p=lets keep it to the regs :P ^!

    rem grab other errors
    if /i !answer! neq n ( echo. & echo ERROR askPy: Please input "y" or "n" & echo Please try again^. & goto :askChange )

    rem user wants defaults
    echo -n | set /p=... yas^!  & goto :decompressExe )

:: _______________________________________________________
                %= runs only if debug(above) bool is true =%
:askPath
:: ask user which for repo dir

echo "Please input path to directory with that CONTAINS __setup and __setup/__setupFiles folder:" & set /p answer= Global Path ^>
echo user req: ^> !answer!

:: grab errors from wrong path input by user
if not exist !answer! ( echo ERROR0a askPatah: no __setup dir !answer!^! & echo NOTE: Double check path location ideally repo folder/dir^. & goto :askPath )
if not exist !answer!\__setupFiles\ ( echo  ERROR0b: no files dir !answer!^! & echo NOTE: Ideally repo folder/dir^. & goto :askPath )

:: update user
if exist !answer!\files\ ( echo __setupFiles\ ok )
if exist !anwser! ( echo __setup\ ok )

set "PATH_=!answer!" && echo "     -^> working directory ^> !PATH_!"

:: _______________________________________________________
:askPyPath
:: ask user which for installed python dir

if %skipPython% == 1 ( goto :decompressExe )

echo Please input path to python^.exe: & set /p answer=Global Path ^>
if %errorlevel% neq 0 ( echo ERROR invalid path: !answer! & echo Please try again^. NOTE: Should not include ^.exe file at the end of path^. Just path to python.exe installed on PC^. & goto :askPyPath )

:: grab errors from wrong path input by user
if not exist !answer! ( echo ERROR askPyPath: path DNE !answer!^! Double check^. & goto :askPyPath )
if not exist !answer!python.exe ( echo ERROR askPyPath: path DNE !answer!^! Double check^. & goto :askPyPath )
if exist !answer! ( echo -^> python directory ^> !PATH_PYTHON! )

set "PATH_PYTHON=!answer!" && echo "     -^> python.exe directory ^> !PATH_PYTHON!"

:: _______________________________________________________
:askExe
:: as user which python dir
echo Install exes? & echo -n | set /p answer=" Answer (y/n): "

:: when changing path option enabled
if /i !answer! == y ( echo lets get all exes in herrrr ...boo & goto :decompressExe )

if /i !answer! neq y (
    echo -n |set /p=ummm....
    rem grab other errors
    if /i !answer! neq n ( echo. & echo ERROR askPYPy: Please input "y" or "n" & echo Please try again^. & goto :askExe )
    echo -n | set /p="...  echo skipping seeing the exes...YAS^!" & goto :decompress )






:: ________________________________________________________________________________________________________________________________________
:: _______________________________________________________
:: _______________________________________________________
:: note above ask labels only performed when debug ==1
:: _______________________________________________________
:: _______________________________________________________
:: ________________________________________________________________________________________________________________________________________

:decompressExe

:: move to top level dir for applicaiton installations
cd C:\ & pause

:: find setup dir with executable files
if not exist %PATH_%__setup\__setupFiles\__exes2install (

    if %debug% ( echo DNE -^> where the EXEs be at?^! )

    mkdir %PATH_%__setup\__setupFiles\__exes2install\exe\
    rem grab errors
    if %errorlevel% neq 0 ( echo ERROR %errorlevel%: mkdir exe )
    if %errorlevel% == 0 (echo exe dir created^. ) )


:: when the exe file exsits or error?
tar -xf %PATH_%__setup\__setupFiles\__exes2install\exe.tar -C %PATH_%__setup\__setupFiles\__exes2install\ 2>&1

:: grab errors
if %errorlevel% == 1 ( echo ERROR %errorlevel%: uncompressing, file exists already? & pause && call :close )

if exist %PATH_%\__setup\__setupFiles\__exes2install\exe\exe\ (
    echo double trouble ^! x2^! & pause
    move %PATH_%\__setup\__setupFiles\__exes2install\exe\* %PATH_%\__setup\__setupFiles\__exes2install\exe\ 2>&1
    rem grab errors
    if %errorlevel% neq 0 (
        echo ERROR %errorlevel%: mv, file exists already? & pause )

    call :removeExeExe
)

:: _______________________________________________________

:installExe
echo --------------------------------------------
echo Begin moving the exes in?
echo --------------------------------------------

if %debug% == 1 ( echo dir output: & dir /b /s %PATH_%__setup\__setupFiles\__exes2install\exe\*.exe & pause )

:: iterate through each exe and install

for /f %%F in ('dir /b /s "%PATH_%__setup\__setupFiles\__exes2install\exe\*.exe"') do (
    echo -n | set /p=" Installing: %%~nxF "

    set "prgm=%%~fF"
    rem Check if the program is installed

    start "installEx" /d "C:\" /wait /b !prgm!

    :endloop
    echo ^| done

)

call :removeExe

:: ________________________________________________________________________________________________________________________________________
:installBonus

winget install voidtools.Everything
echo bobus

:install7zip
echo -n | set /p="+ 7zip..."
:: ensure 7zip is installed for installing WinPython
winget install 7zip.7zip
if %errorlevel% neq 0 ( echo ERROR %errorlevel%: attempt to install 7zip & pause & call :close )

:: _______________________________________________________

:decompress
:: as user which python dir
echo --------------------------------------------
echo Begin installing python:
echo --------------------------------------------


if not exist %PATH_%__setup\__setupFiles\__exes2install\!pyType!\ (
    if %debug% == 1 ( echo DNE -^> where the !pyType! be at?^! )

    mkdir %PATH_%__setup\__setupFiles\__exes2install\!pyType!\
    rem grab errors
    if !errorlevel! == 0 ( echo !pyType! dir created^. )
    if !errorlevel! == 1 ( echo ERROR pyinstalldecom !errorlevel!: mkdir !pyType! )

:: when the exe file exsits or error?
rem tar -xf %PATH_%__setup\__setupFiles\__exes2install\pythonInstallExe.tar -C C:\ 2>&1

:: _______________________________________________________

:installPython

echo install req py or winpy & pause

winget install !pyType!.!pyType! --version !pyVersion!
if %errorlevel% neq 0 (
    echo.
    echo ERROR: %errorlevel%
    echo Please try again.
    pause & call :close
    )
echo ^| done

dir /s /b C:\ | findstr /i ".*\\py.*\\python.exe"

if !errorlevel! neq 0 ( echo ERROR no python installed? & pause & call :close )

:: iterate through each pos py and find location
for /F "tokens=*" %A in ('dir /s /b C:\ ^| findstr /i ".*\\py.*\\python.exe"') do (
    echo found snakes in the grass...
    echo %A & pause
    set testpy=%A

    for /f "delims=" %%a in ('!testpy! --version') do set "output=%%a"

    if !errorlevel! neq 0 ( echo ERROR no python installed? & pause & call :notThisOne )
    if !errorlevel! == 0 ( echo -n | set /p=-^> installed python path^: !testpy! )
    if !testpy! == !PYTHON_PATH! ( set PYTHON_PATH=!testpy! & echo match ^! )
    echo output !output!

    :notThisOne
    echo not this one

)

:: delete dir with .exe file post install

echo -------------------------------------------- & call :removePy


:: ________________________________________________________________________________________________________________________________________

:chkVenv

if %debug% == 1 && %installPython% == 0 ( echo -n | set /p =Check env... )
set "SETUP=%PATH_%_venv\Scripts"


if not exist %PATH_% ( echo ERROR chkvenv: no dir !PATH_!^! & echo NOTE: Double check path location ideally repo folder/dir^. & call :askPath )
cd %PATH_%

:: Ensure virtual environment exists if not create it with local python installed
if exist %PATH_%_venv (
    echo A virtual environment exists^^!

    rem default will delete old venv each time
    if %debug% == 1 ( echo -n | set /p=rming... & call :removeVenv )

    rem new venv creation
    "%PATH_PYTHON%" -m venv _venv >nul 2>&1
    if %errorlevel% neq 0 ( echo Attempted to make env ERRORa !errorlevel! )
    echo -n | set /p="Fresh venv created^! " )

echo.
echo --------------------------------------------
echo --------------------------------------------

:: ________________________________________________________________________________________________________________________________________

:actVenv

if %debug% == 1 ( echo is this the file? !SETUP! & pause )

:: Ensure virtual environment exists if not create it with local python installed
if not exist %SETUP%\activate.bat (
    echo %SETUP%\activate.bat DNE meaning not found^! Creating venv...
    "%PATH_PYTHON%" -m venv venv
    if %errorlevel% neq 0 (
        echo Attempted to make env ERRORb
        if %debug% == 0 ( echo NOT in DEBUG MODE... & echo -n | ping -n 10 127.0.0.1 >nul && echo closing! & call :close )
        if %debug% == 1 ( echo Enabling cmd... && echo Ready! & cmd /k ) )
    )

:: Activate the virtual environment
call %SETUP%\activate.bat
if %errorlevel% neq 0 (
    echo Attempted to call activation of env...ERRORa
    if %debug% == 0 ( echo NOT in DEBUG MODE... & echo -n | ping -n 10 127.0.0.1 >nul && echo closing! & call :close )
    if %debug% == 1 ( echo Enabling cmd... && echo Ready! & cmd /k ) )

:: ________________________________________________________________________________________________________________________________________

:setIcon
:: Get the current directory of the script
echo repoPath %PATH_% & pause
set "iconPath=%PATH_%__setup\__setupFiles\icons\"
set "setupIcon=__setup.ico"
set "fsoIcon=__fso.ico"

set "shortcutSetupPath=%PATH_%\__launchSetup.bat.lnk"
set "shortcutFSOPath=%PATH_%\LaunchFSO.bat.lnk"

:: Use PowerShell to update the shortcut
powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; $shortcut = $WshShell.CreateShortcut('%shortcutSetupPath%'); $shortcut.IconLocation = '%iconPath%'; $shortcut.Save()"
if %errorlevel% neq 0 ( echo ERROR icon: %errorlevel% & echo Please try again^. & pause & goto :close )

echo able to work on __setup icon
powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; $shortcut = $WshShell.CreateShortcut('%shortcutPath%'); $shortcut.IconLocation = '%iconPath%'; $shortcut.Save()"
if %errorlevel% neq 0 ( echo ERROR icon: %errorlevel% & echo Please try again^. & pause & goto :close )

echo Shortcut icons updated successfully^^! & pause

:: ________________________________________________________________________________________________________________________________________


:: Use the correct Python path inside the venv
set PYTHON_EXE=%SETUP%\python.exe
:: Check if Python inside the venv exists
if not exist !PYTHON_EXE! ( echo ERROR: Python.exe inside venv not found! & set debug=1 && call :askPyPath )

if %skipVenv% == 1 ( echo Activated venv -- & goto :decompressExe )


:: Display which venv is being used
echo -n | set /p="Virtual Environment: " & python --version
echo --------------------------------------------
echo           starting install...
echo --------------------------------------------

:: ________________________________________________________________________________________________________________________________________

:install_pip
echo -n | set /p="+ pip..."

where pip >nul 2>&1
if %errorlevel% neq 0 (
    echo " -^> installing..."
    python -m get_pip.py
    python -m ensurepip
    python -m pip install --upgrade pip
    if %errorlevel% neq 0 (
        echo ERROR: Pip installation failed.
        pause
    ) else (
        echo installed          ^| done
    )
) else ( echo           ^| done )


:: ________________________________________________________________________________________________________________________________________

:install_git

echo -n | set /p="+ git..."

if %skipGit% == 1 ( echo skipping git... & goto :install_pkgs )

where git >nul 2>&1
if %errorlevel% neq 0 (
    echo " -^> installing..."
    winget install Git.Git
    if !errorlevel! neq 0 ( echo ERROR: Git installation failed^. & pause ) else ( echo installed        ^| done )
) else ( echo           ^| done  )

:: ________________________________________________________________________________________________________________________________________
:install_pkgs

echo -n | set /p="+ packages...     | please wait..."

set "timepause=12"


if %dots% == 1 (
    echo starting bools?

    start "ProgressDots" /b cmd /c "for /L %%i in (1,1,1000) do ( @echo -n | set /p=. <nul & @echo -n | ping -n 2 127.0.0.1 >nul & @echo -n ^r^r | set /p=.. <nul )"

    rem if !errorlevel! == 9059 ( echo ERROR: hit another error !errorlevel! )

    echo before install please wait... )
:: install package requests from text file & show any errors

python -m pip install -r %PATH_%\__setup\files\requirements.txt >nul 2>&1
if %errorlevel% neq 0 ( echo ERROR: hit another package error,  %errorlevel% )
if %errorlevel% == 0  ( echo      ^| done )


:: _______________________________________________________


set dots=0
if %dots% ==1 ( call :killDots )

:: _______________________________________________________

:fix_pyebus
echo -n | set /p="+ pyebus ... "
xcopy "%PATH_%\camera_control\pyebus\" "%PATH_%\venv\Lib\site-packages\pyebus" /E /I /Y >nul 2>&1
if %errorlevel% neq 0 ( echo ERROR: hit another error %errorlevel% & pause )
if %errorlevel% == 0  ( echo      ^| done )

:: ________________________________________________________________________________________________________________________________________
            %= KEEP THE INSTALLATION TERMINAL OPEN till user closes =%
:lastjubba
echo -n |set/p="lastjubba: "

rem ask user which python to use
echo Setup done^! Do you to input any cmds? & set /p answer="Answer (y/n):"

if /i !answer! == y ( echo Setting up cmd prompt... & cmd /k )
if /i !answer! neq y (
    echo -n |set /p=meow no last jubbie^!
    if /i !answer! neq n ( echo "ERROR lastjubba: Please only enter" & pause & goto :lastjubba )
    )
if /i !answer! == n ( echo __setup done^! )

:: ________________________________________________________________________________________________________________________________________
:: label used to close out or exit batch file
:: ensure venv deactivated and variable locality ends

:close
    deactivate & echo vevn deactivated^.
    endlocal & echo --------------^> closing^!
    rem inform user of closing and close after number of sec delay
    echo -n | ping -n %closetime% 127.0.0.1 >nul && exit

:: ________________________________________________________________________________________________________________________________________
:: labels ( or global callbacks ) only referenced by > call :label
:: if using goto :label note batch will compile all labels below :label referenced

:removePy
    rmdir /s /q %PATH_%\__setup\files\pythonInstallExe\ 2>&1 || echo ERROR !errorlevel!: tried to rm old python dir  & exit /b
    echo -n | set /p="deletered those nasty pythons^! " & exit /b

:removeVenv
    rmdir /s /q %PATH_%_venv 2>&1 || echo ERROR !errorlevel!: tried to rm old EXES dir & exit /b
    rem when no error or
    echo -n | set /p="deletered that dusty env^! " & exit /b

:removeExe
    rmdir /s /q %PATH_%\__setup\files\exe\ 2>&1 || echo ERROR !errorlevel!: tried to rm old EXES dir  & exit /b
    echo -n | set /p="deletered those nasty exes^! " & exit /b

:removeExeExe
    rmdir /s /q %PATH_%\__setup\files\exe\exe\ 2>&1 || echo ERROR !errorlevel!: tried to rm old EXES dir  & exit /b
    echo -n | set /p="deletered those nasty exes^! " & exit /b

:killDots
    echo -n | set /p=killing dots^!
    taskkill /FI "WINDOWTITLE eq ProgressDots" /T /F >nul 2>&1
    if %errorlevel% neq 0 ( echo ERROR: hit another error,  %errorlevel% & pause )

    echo dots      ^| killed & exit /b