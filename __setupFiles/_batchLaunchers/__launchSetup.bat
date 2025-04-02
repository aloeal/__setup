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
:: ________________________________________________________________________________________________________________________________________

@echo off
:: install desired
set "pyType=Python"
set "pyVersion=3.9.13"

:: so pc wont remember variables to enviroment
setlocal enabledelayedexpansion
:: ________________________________________________________________________________________________________________________________________


echo ________________________________ venv auto setup ______________________________________
echo NIST: 675.02                                                   Last mod: March 27 2025
echo Written by: Allie Christensen
echo _______________________________________________________________________________________
echo            Refer to README to see information regarding this script
rem    ________________________________________________________________________
rem      FAST MODE:      no questions, OVERWRITES any winpythin or python...
rem                              ...on pc, installs all exes ^& packages
rem      NORMAL MODE:    Qs per install
rem      DEBUG MODE:     Qs, debugging output to terminal ^& command line
rem                              dialog (cmd /k when needed)
echo _______________________________________________________________________________________

:: ________________________________________________________________________________________________________________________________________
                    %= USER may have to change below! =%

set allie=0

:: expedite path setting for allie on sslap
if !allie! == 1 ( set "PATH_=C:\Users\anc32\GitItUp\" & set "PATH_PYTHON=C:\Program Files\Python39\python.exe" & goto :done )

:: path to repo
:: nuc1
rem set "PATH_=C:\OTTRepos\FSOTerminal\__setup"
:: alt path to repo, baldur?
set "PATH_=C:\Users\fcomb\OTTRepos\FSOTerminal\__setup"

:: path to installed python on pc
:: nuc1
set "PATH_PYTHON=C:\WPy64-3940\python-3.9.4.amd64\"
:: alt path to python baldur?
rem set "PATH_PYTHON=C:\WinPy3.9.4\WPy64-3940\python-3.9.4.amd64\"

set "venvName=__fsoVenv"

:done
echo. & if %allie% ==1 ( echo -^> Allie params set^! & echo. )

:: Above points to the correct location for WinPython 3.9.40 on Spare (and possibly other computers), if this is wrong consider using dev_2024_FSO_startup_altfileloc.bat instead

:: ________________________________________________________________________________________________________________________________________
:: bool if user wants option to skip many qs and go for defaults
set ask=1

rem if python already installed on pc
set skipPython=1
rem bools if user wants debug terminal startup or change installs
set skipVenv=0
rem user wants to install git bash and executables in exe.tar
set skipExe=1
set skipGit=1
set skipBonus=1

rem bonus exe installable via winget
set "bonus1=7zip.7zip"
set "bonus2=voidtools.Everything"
set "bonus3=Microsoft.VCRedist.2013.x86"

:: CHANGE ME if you add or subtract bonus installs...should match number of installs
set bonus=3

:: ________________________________________________________________________________________________________________________________________

:: do not change below
set closetime=10
set dots=0
set debug=0


:: default for fso python install & setup repo structure
set "setupFiles=__setupFiles\"


:: ________________________________________________________________________________________________________________________________________

echo Working DIR: -default       ^> %PATH_%
echo python DIR:  -default       ^> !PATH_PYTHON!
echo --------------------------------------------------------------------

:: ________________________________________________________________________________________________________________________________________
            %= asking for fastmode  =%
:: user interaction with setup

:: no fast setup go to usual setup
if %ask% == 0 ( goto :askDebug )


:askFast

echo FAST setup mode? & set /p answer=" Answer (y/n): "

rem when cmd option enabled
if /i !answer! == y ( echo -------------------------------------------- & echo FAST MODE: & echo -------------------------------------------- & goto :decompressExe )

if /i !answer! neq y (
    rem grab other errors
    if /i !answer! neq n ( echo ERROR Fast: Please input "y" or "n" & echo Please try again^. && goto :askFast )

    rem when cmds disabled, note default of debug = false == 0
    echo --------------------------------------------

    echo slowsy ENABLED )


:: ________________________________________________________________________________________________________________________________________
            %= all user input if not debug =%
:askDebug

echo DEBUG setup mode? & set /p answer=" Answer (y/n): "

:: when cmd option enabled
if /i !answer! == y ( echo DEBUG MODE: & set debug=1 & echo -------------------------------------------- & goto :askPyType )

if /i !answer! neq y (
    echo -n | set /p=meow no^! ...meow...
    rem grab other errors
    if /i !answer! neq n ( echo. & echo ERROR askPy: Please input "y" or "n" & echo Please try again^. & goto :askDebug )

    rem when cmds disabled, note default of debug = false == 0
    echo NORMAL MODE: )

:: ________________________________________________________________________________________________________________________________________
:: _______________________________________________________
:: _______________________________________________________
:: note below ask labels only performed when debug ==1
:: _______________________________________________________
:: _______________________________________________________
:: ________________________________________________________________________________________________________________________________________

:: normal setup if python installed -> ask for path & repo path 
if %skipPython% == 1 ( echo python is setup already by bool & goto :askPath )


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
:: Ask user for Python type (WinPython or Python)

:askPyType

echo Select Python type: WinPython or Python
set /p pyType="Answer (WinPython/Python = w/p only): "


set "pyType=!pyType!"

:: Validate input
if /i "!pyType!" == "w" ( set "pyType=WinPython" & goto :resultTrue ) else if /i "!pyType!" == "p" ( set "pyType=Python" & goto :resultTrue ) else ( echo false & call :resultFalse )

:resultFalse
:: reroute user back to question if answer is invalid
echo ERROR: Invalid input. Please enter "w" or "p". Please try again^.
goto :askPyType

:resultTrue
:: update user with choosen installs avaliable versions
call :_displayVer

:: _______________________________________________________

:askVersion
:: Ask user for version

echo Enter the version you want to install (e.g., 3.10.9):
set /p pyVersion="Requested Version: "
echo ------

:: Validate input
:confirmVersion
echo Press N within 5 seconds to ^change version, or please wait...
choice /c yn /t 5 /d Y /m "Confirming %pyType% %pyVersion% installation"
if %errorlevel% == 2 ( echo "You pressed a key before timeout -> changing version!" & pause & call :confirmVersion ) else if %errorlevel% == 0 ( echo ERROR %errorlevel%: version? & cmd /k ) else ( echo CONFIRMED )

if %debug% == 1 (
    rem take user thru qs if debuggin else skip
    if %ask% == 1 ( echo faster... & goto :decompressExe )
    echo Beginning of 4Qs -------
    )

:: Continue with further script logic...
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

echo Please input path to directory with that CONTAINS __setup and __setup/__setupFiles folder: & set /p answer=" Global Path > "

:: update user
if exist !answer!\ ( 
    echo __setup\ ok 
    if exist !anwser!\__setupFiles\ ( 
        echo __setupFiles\ ok 
        goto :setPath
    )

)

:: grab errors from wrong path input by user
if not exist !answer!\ ( echo ERROR0a askPatah: no __setup dir !answer!^! & echo NOTE: Double check path location ideally repo folder/dir^. & goto :askPath )
if not exist !answer!\__setupFiles\ ( echo  ERROR0b: no files dir !answer!^! & echo NOTE: Ideally repo folder/dir^. & goto :askPath )
if not exist !answer! ( echo ERROR0c askPatah: no __setup dir !answer!^! & echo NOTE: Double check path location ideally repo folder/dir^. & goto :askPath )


:setPath
set "PATH_=!answer!"
echo      -^> working directory ^> !PATH_!

:: _______________________________________________________
:askPyPath
:: ask user which for installed python dir

:: skip asking python qs if normal setup w/o debug
if %ask% == 0 ( set "PATH_PYTHON=%PATH_PYTHON%\python.exe" & goto :decompressExe )

echo Please input path to python^.exe: 
set /p answer="Global Path > "
pause 
:: grab errors from wrong path input by user
if exist !answer! ( echo -^> python directory ^> !PATH_PYTHON! & goto :fixed)
if exist !answer!\ ( echo -^> python directory ^> !PATH_PYTHON! & goto :fixed)

if not exist !answer! ( echo ERROR askPyPath: path DNE !answer!^! Double check^. & if exist "!answer!\" ( echo fixed1 & goto :fixed )  )
if not exist !answer!*.exe ( echo ERROR askPyPath: path DNE !answer!^! Double check^. & if exist !answer!\*.exe (echo fixed2 &  goto :fixed )  )
echo ERROR: Fix path 
goto :askPyPath 

:fixed
set "PATH_PYTHON=!answer!\python.exe" && echo     -^> python.exe directory ^> !PATH_PYTHON!


:: _______________________________________________________
:askExe

if %skipExe% == 1 ( echo none of those past ghosts & goto :installBonus)
:: as user which python dir
echo Install exes? & echo -n | set /p answer=" Answer (y/n): "

:: when changing path option enabled
if /i !answer! == y ( echo lets get all exes in herrrr ...boo & goto :decompressExe )

if /i !answer! neq y (
    echo -n |set /p=ummm....
    rem grab other errors
    if /i !answer! neq n ( echo. & echo ERROR askPYPy: Please input "y" or "n" & echo Please try again^. & goto :askExe )
    echo -n | set /p="...  echo skipping seeing the exes...YAS^!" & set skipBonus=1 & goto :installBonus )






:: ________________________________________________________________________________________________________________________________________
:: _______________________________________________________
:: _______________________________________________________
:: note above ask labels only performed when debug ==1
:: _______________________________________________________
:: _______________________________________________________
:: ________________________________________________________________________________________________________________________________________

:decompressExe

:: move to top level dir for applicaiton installations
cd C:\

set "setupPath_=%PATH_%\%setupFiles%"

if %skipExe% == 1 ( goto :installBonus )

:: find setup dir with executable files
if not exist %setupPath_%__exes (
    echo jammi & pause

    if %debug% == 1 ( echo debugger mess -^> where the EXEs be at?^! & cmd /k )

    mkdir %setupPath_%__exes
    rem grab errors
    if !errorlevel! neq 0 ( echo ERROR !errorlevel!: mkdir exe )
    if !errorlevel! == 0 ( echo exe dir created^. ) )


:: when the exe file exsits or error?
tar -xf %setupPath_%__exes\exes.tar -C %setupPath_%__exes\ 2>&1

:: grab errors
if %errorlevel% == 1 ( echo ERROR %errorlevel%: uncompressing, file exists already? && call :close )

if exist %setupPath_%__exes\exe\exe\ (
    echo "double trouble ! x2 !" & pause
    move %setupPath_%__exes\exe\* %setupPath_%__exes\exe\ 2>&1
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

if %debug% == 1 ( echo dir output: & dir /b /s %setupPath_%__exes\exe\*.exe  )

:: iterate through each exe and install

for /f %%F in ('dir /b /s "%setupPath_%__exes\exe\*.exe"') do (
    echo -n | set /p=" Installing: %%~nxF "

    set "prgm=%%~fF"
    rem Check if the program is installed

    start "installEx" /d "C:\" /wait /b !prgm!

    :endloop
    echo ^| done )

call :removeExe

:: ________________________________________________________________________________________________________________________________________
:installBonus

:: user wants to skip exe files so...
if %skipBonus% == 1 (
    rem just install 7 zip if user want to install winpy or py
    if %skipPython% ==1 ( echo SKIPPING around...  & goto :chkVenv )
     rem just install 7 zip if user want to install winpy or py
    if %skipPython% ==0 ( winget install %bonus1% & echo no bonus this year & goto :decompress )
    )

if %bonus% GTR 1 ( echo + Bonuses... ) else if %bonus% == 1 ( echo + Bonus... )
echo.

for /l %%i in ( 1, 1, %bonus% ) do (

    call set bonusI=%%bonus%%i%%
    winget install !bonusI! >nul 2>&1
    if !errorlevel! GTR 1 ( echo ERROR !errorlevel! bonusI: attempt to install %bonusI% & pause & if %debug% ==1 ( cmd /k ) else ( call :close ) )
    if !errorlevel! LSS 0 ( echo    !bonusI! & echo             installed                 ^| done) & rem ^*^*^*ERROR !errorlevel! ==  -1978335189
    if !errorlevel! == 0 ( echo     !bonusI! & echo             -^> installing...         ^| done )
    )

:: _______________________________________________________

:decompress
:: as user which python dir
echo --------------------------------------------
echo Installation: %pyType% %pyVersion%
echo --------------------------------------------

set cleanVersion=!pyType!_%pyVersion:.=%
set cleanInstall=C:\!cleanVersion!

if not exist "%cleanInstall%" (
    echo panda
    if %debug% == 1 ( echo DNE -^> where the !pyType! be at?^! )
    mkdir %cleanInstall%
    rem grab errors
    if !errorlevel! == 0 ( echo %cleanInstall% dir created^. )
    if !errorlevel! neq 0 ( echo ERROR pyinstalldecom !errorlevel!: mkdir %cleanInstall% )
    )

:: _______________________________________________________

:installPython

if %debug% ==1 ( echo attempting python install... )

:: determine if version is one or two char for install

if "%pyVersion:~3,1%" == "." ( set "idVer=%pyVersion:~0,3%" ) else if "%pyVersion:~4,1%" == "." ( set "idVer=%pyVersion:~0,4%" ) else ( echo error det ver & cmd /k )
echo verrbbbb %idVer%
winget install "%pyType%.%pyType%.%idVer%" --version "%pyVersion%" --location "%cleanInstall%" --no-upgrade --wait --silent
if %errorlevel% GTR 1 ( echo ERROR %errorlevel% bonusI: attempt to install %bonusI% & call :close
) else if %errorlevel% LSS 0 (
    echo -n | set /p="%pyType% is installed already^!..."
    winget list --id "%pyType%.%pyType%"
    rem winget uninstall Python.Python.3.9 --version 3.9.4
    if %ask% == 0 ( echo %pyType% overwrite...impending^! & winget uninstall "%pyType%.%pyType%.%idVer%" --version "%pyVersion%" && goto :installPython || ( echo beans fix me & cmd /k ) )
    echo past ask

    if %debug% == 1 (
        echo -^> Please confirm you want to OVERWRITE installation by manual uninstall...use line below ^& id in table output to terminal^.
        echo        ^> winget uninstall ^<name.name.deployment^> --version ^<version^> ^&   & rem -1978335212
        echo           ex.... Python^.Python^.3^.9 --version 3^.9^.4
        echo USER: uninstall %pyType% & cmd /k
    ) else ( echo Uninstalling %pyType% %idVer%... & winget uninstall "%pyType%.%pyType%.%idVer%" --version "%pyVersion" )
    echo done uninstallin yoooo & goto :installPython
   ) else if %errorlevel% == 0 ( echo      DONE    ^| yas  & set "PATH_PYTHON=%cleanInstall%" )

:: delete dir with .exe file post install
echo -------------------------------------------- 

:: ________________________________________________________________________________________________________________________________________

:chkVenv

set "venvPath_=%PATH_%\%venvName%"
:: Use the correct Python path inside the venv
set PYTHON_EXE=%PATH_PYTHON%\python.exe

if %skipVenv% == 1 ( echo Skipping venv -- & goto :lastjubba )

if %debug% == 1 ( echo -n | set /p =Check env... )

:: Ensure virtual environment exists if not create it with local python installed
if exist %venvPath_% (
    echo A virtual environment exists^^!

    rem default will delete old venv each time
    if %debug% == 1 ( echo -n | set /p=rming... & call :removeVenv )

    echo boom ) 

:: create venv fresh each time 
if not exist %venvPath_% ( echo NO virutal environment present at: !venvPath_!^! & echo NOTE: Double check path location ideally repo folder/dir ^& close if incorrect^. & goto :createVenv )

echo.
echo --------------------------------------------
echo --------------------------------------------

:: ________________________________________________________________________________________________________________________________________

:actVenv

if %debug% == 1 ( echo trying to activate new venv... )

:: Activate the virtual environment
call %venvPath_%\Scripts\activate.bat

if %errorlevel% neq 0 (
    echo Attempted to call activation of env...ERRORa
    if %debug% == 0 ( echo NOT in DEBUG MODE... & echo -n | ping -n 10 127.0.0.1 >nul && echo closing! & call :close )
    if %debug% == 1 ( echo Enabling cmd... && echo Ready! & cmd /k ) )
echo VENV ACTIVATED ----

:: ________________________________________________________________________________________________________________________________________




:: Check if Python inside the venv exists
if not exist !PYTHON_EXE! ( echo ERROR: Python.exe inside venv not found! & set debug=1 && call :askPyPath )

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
    echo before install please wait...

    start "ProgressDots" /b cmd /c "@echo -n | set /p=. <nul & @echo -n | ping -n 2 127.0.0.1 >nul & @echo -n ^r^r | set /p=.. <nul "
 )

:: suppress output if not debuggin ">nul"
if %debug% == 0 ( 
    python -m pip install -r %setupPath_%__files\requirements.txt >nul 2>&1 
    if !errorlevel! neq 0 ( echo ERROR pkgsD: hit another package error,  %errorlevel% )
    if !errorlevel! == 0  ( echo      ^| done ) 
) else if %ask% == 0 ( 
    python -m pip install -r %setupPath_%__files\requirements.txt 2>&1 
    if !errorlevel! neq 0 ( echo ERROR pkgs: hit another package error,  %errorlevel% )
    if !errorlevel! == 0  ( echo      ^| done )
) else (     
    python -m pip install -r %setupPath_%__files\requirements.txt 2>&1 
    if !errorlevel! neq 0 ( echo ERROR pkgsF: hit another package error,  %errorlevel% )
    if !errorlevel! == 0  ( echo      ^| done ) )

:: _______________________________________________________


if %dots% ==1 ( call :killDots )

:: _______________________________________________________

:fix_pyebus
echo -n | set /p="+ pyebus ... "

for %%A in ("%PATH_%") do (
    set "repoPath=%%~dpA"
    set "repoPath=!repoPath!sysCode\"
    echo REPO at: !repoPath!
    )

xcopy "%repoPath%camera_control\pyebus\" "%venvPath_%\Lib\site-packages\pyebus" /E /I /Y >nul 2>&1
if %errorlevel% == 0  ( echo      ^| done 
) else if %errorlevel% == 4  ( echo ERROR xcopy %errorlevel%: BAD cmd syntax & call :close 
) else if %errorlevel% ==1 ( echo ERROR xcopyNO: NO Files found in pyebus & call :close 
) else ( echo ERROR xcopy FINAL%errorlevel%: starting cmd line & cmd /k ) 
:: ________________________________________________________________________________________________________________________________________
            %= KEEP THE INSTALLATION TERMINAL OPEN till user closes =%
:lastjubba
echo --------------------------------------------
echo -n |set/p="last jubba: "

:setIcon
:: Get the current directory of the script

set "iconPath=%setupPath_%__icons\"

set "setupIcon=%iconPath%__setup.ico"
set "mainIcon=%iconPath%__main.ico"


set "shortcutSetupPath=%PATH_%\__launchSetup.lnk"
set "shortcutFSOPath=%repoPath%\LaunchSystem.lnk"
set "desktopPath=%USERPROFILE%\Desktop\freeSpaceOptics.lnk"



:: Use PowerShell to update the shortcut
powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; $shortcut = $WshShell.CreateShortcut('!shortcutSetupPath!'); $shortcut.IconLocation = '!setupIcon!'; $shortcut.Save()"
if %errorlevel% neq 0 ( echo ERROR Setup icon: %errorlevel% & echo Please try again^. & pause && call :close )

powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; $shortcut = $WshShell.CreateShortcut('!shortcutFSOPath!'); $shortcut.IconLocation = '!mainIcon!'; $shortcut.Save()"
if %errorlevel% neq 0 ( echo ERROR Main icon: %errorlevel% & echo Please try again^. & pause && call :close )
powershell -Command "$WshShell = New-Object -ComObject WScript.Shell; $shortcut = $WshShell.CreateShortcut('!desktopPath!'); $shortcut.IconLocation = '!mainIcon!'; $shortcut.Save()"
if %errorlevel% neq 0 ( echo ERROR Desktop icon: %errorlevel% & echo Please try again^. & pause && call :close )

echo Shortcut icons updated successfully^! 
echo --------------------------------------------

:: ________________________________________________________________________________________________________________________________________

if %ask% ==0 ( echo fasterer^! & call :close ) else if %debug% == 0 ( echo Done & call :close ) else ( echo last Q! ) 
rem ask user which python to use
echo Setup done^! Do you to input any cmds? & set /p answer="Answer (y/n):"

if /i !answer! == y ( echo Setting up cmd prompt... & cmd /k )
if /i !answer! neq y (
    echo -n |set /p=meow no last jubbie^!
    if /i !answer! neq n ( echo "ERROR lastjubba: Please only enter" & pause & goto :lastjubba )
    )
if /i !answer! == n ( echo __setup done^! & call :close )



:: ________________________________________________________________________________________________________________________________________
:: labels ( or global callbacks ) only referenced by > call :label
:: if using goto :label note batch will compile all labels below :label referenced

:removeVenv
    rmdir /s /q %PATH_%\%venvName% 2>&1 || echo ERROR !errorlevel!: tried to rm old EXES dir & exit /b
    rem when no error or
    echo -n | set /p="deletered that dusty env^! " & exit /b

:createVenv
    rem new venv creation
    "%PYTHON_EXE%" -m venv %venvPath_%\ 2>&1 || ( echo ERRORa !errorlevel!: Attempted to make env. && if %debug% == 1 ( echo Enabling cmd... && echo Ready! & cmd /k ) else ( echo oopsie & call :close ) )
    rem if %debug% == 0 ( echo NOT in DEBUG MODE... & echo -n | ping -n 10 127.0.0.1 >nul && echo moving on! )
    echo -n | set /p="Fresh venv created! "
    echo ----- & goto :actVenv

:removePy
    rmdir /s /q %setupPath_%\__files\ 2>&1 || echo ERROR !errorlevel!: tried to rm old python dir  & exit /b
    echo -n | set /p="deletered those nasty pythons^! " & exit /b

:removeExe
    rmdir /s /q %setupPath_%__exes\exe\ 2>&1 || echo ERROR !errorlevel!: tried to rm old EXES dir  & exit /b
    echo -n | set /p="deletered those nasty exes^! " & exit /b

:removeExeExe
    rmdir /s /q %setupPath_%__exes\exe\ 2>&1 || echo ERROR !errorlevel!: tried to rm old EXES dir  & exit /b
    echo -n | set /p="deletered those nasty exes^! " & exit /b

:killDots
    taskkill /FI "WINDOWTITLE eq ProgressDots" /T /F >nul 2>&1
    if %errorlevel% neq 0 ( echo ERROR: hit another error,  %errorlevel% & pause )

    echo dots      ^| killed & exit /b

:_displayVer
    echo ------ & echo Requested install : %pyType%
    echo ------ & echo Avaliable Versions & echo ------
    winget search --id %pyType%.%pyType% --source winget -n 20

    if %errorlevel% neq 0 ( echo ERROR ver: %errorlevel% & pause & cmd /k )
    echo ------ & exit /b

:displayVersions
    echo ------
    set ver = %pyVersion:~0,3%
    winget search --id Python.Python --source winget --moniker python

    winget search --versions="%pyType%!ver!" --source winget --moniker python 2>nul
    if %errorlevel% neq 0 ( echo "ERROR versions %errorlevel%" & goto :askVersion )
    echo ------ & exit /b


:: ________________________________________________________________________________________________________________________________________
:: label used to close out or exit batch file
:: ensure venv deactivated and variable locality ends

:close
    deactivate & echo vevn deactivated^.
    endlocal & echo --------------^> closing^!
    rem inform user of closing and close after number of sec delay
    echo -n | ping -n %closetime% 127.0.0.1 >nul 
    exit