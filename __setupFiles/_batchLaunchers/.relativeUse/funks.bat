
@echo off & setlocal enabledelayedexpansion


:startFunky
    call :_init

    rem look for repository cloned ontol pc using generalized paths in env_var.bat
    call :findDir

    call :switchGitPull

    rem look for pyType installed on pc or install 
    call :find_py

    rem set requested venv path as variable for parent batch
    call :setVenv

    rem determine if venv exists or needs creation
    call :chkVenv

    rem belows essentially returns code back to file that called originally
    goto :eof

:startAlpha
    call :_init

    rem determine if venv exists or needs creation
    call :chkVenv

    call :actVenv
    
    rem belows essentially returns code back to file that called originally
    goto :eof


:_init
    set "parent=%~1"

    rem open an admin terminal for user to ensure permissions are not an issue with installations 
    call :openAdmin
    
    cd /d "%~dp0\..\..\.."
    call :helloScript

    rem import variables from env_var.bat
    call :load_var

    rem belows essentially returns code back to file that called originally
    if %parent% == "%file%" ( call :startAlpha & echo alpha ) else ( call :startFunky & echo funky )
    
rem *********************************************************************************************
rem *******   sys & user                             *******************************************
rem *********************************************************************************************

:openAdmin
	rem Ensure script runs as administrator
	
	set "PATH_script=%~dp0"

	net session >nul 2>&1
	if %errorlevel% neq 0 (
	    echo Elevating privileges...
	    powershell -Command "Start-Process cmd -ArgumentList '/k cd /d ""%PATH_script%""' -Verb RunAs" && goto :eof
	)
    cd /d "%~dp0\..\.." & call :displayCwd

    echo ****************** & echo starting up... & echo ******************

:: ________________________________________________________


:helloScript
    echo -- aloeBrooks %repo% %branch%  -- Last mod: Sep 22 2025
    goto :eof

:helloSoftware
    set "title=%~1"
    set "lastMod=%~2"
    echo -- %title% -- Last mod: %lastMod%
    goto :eof

:: ________________________________________________________

:load_var

    echo where env_vars.bat & cd 
    call env_vars.bat || (
        echo [ERROR] Failed to load env_vars.bat
        goto :eof
    )
    echo "      == RELOADED env_var.txt =="
    goto :eof

:: ________________________________________________________

:displayCwd

    echo -n | set /p=moved to.. current working dir: & cd
    goto :eof

:: ________________________________________________________

rem to use copy below
rem call :askQ "winpython or python" "w" "p"

:askQ
    set "question=%~1"
    set "ansTrue=%~2"
    set "ansFalse=%~3"
    set /p answer="%question%"


    set "ans=!answer!"

    rem Validate input
    if /i "!ans!" == "%ansTrue%" ( goto :resultTrue ) else if /i "!ans!" == "%ansFalse%" ( goto :resultFalse ) else ( echo NEITHER & call :resultOther )

    :resultFalse
    rem reroute user back to question if answer is invalid
    echo result false
    goto :eof

    :resultTrue
    rem update user with choosen installs avaliable versions
    echo result true
    goto :eof

    :resultOther
    rem reroute user back to question if answer is invalid
    echo ERROR: Invalid input. Please enter "w" or "p". Please try again^.
    goto :eof


rem *********************************************************************************************
rem *******   data or git                            *******************************************
rem *********************************************************************************************


:findDir

    set flag=False 
     
    rem Loop through each path in repoPATHs
    for %%P in (%repoPATHs%) do (
        set "currentPath=%%~P\"
        for %%Q in (!repoNames!) do (
            set "currentRepo=%%~Q\" 

     
            if exist "!currentPath!!currentRepo!" (

                set flag=True
                set "PATH_=!currentPath!!currentRepo!"
                echo -n |set /p="echo !currentPath!!currentRepo!\"

                goto :repoFound ) else ( echo -n |set /p="...!currentPath!!currentRepo!...x"   )
        )
     )



    if %flag% == False ( echo Initializing ERROR: Repo not found. & if !debug! ==1 ( echo debug me & cmd /k ) else ( pause & echo no debug & goto :eof )) 

    :repoFound
    echo. & echo    -^> REPO found : !PATH_! & echo. 
    goto :eof

:: ________________________________________________________

:switchGitPull
    cd %PATH_% >nul || ( echo bad %PATH_% & pause )
    git switch %branch% >nul || ( echo switch ERTROR & pause )
    echo confirm pull? & pause
    call :askQ "Confirm pull of %repo%/%branch%" "y" "n" || ( echo error ASKQ & goto :eof )
    git pull >nul || ( echo bad pull & pause )
    goto :eof 
:: ________________________________________________________

:tryPull

    rem Pull latest for flex if it's a separate repo
    IF EXIST _init\.git (
        echo === UPDATING flex REPO ===
        cd _init
        git pull origin %_initBranch% || ( echo bad & pause )
        cd ..

    ) ELSE (
        echo ^[^!^] _init is missing or not a git repo!
    )

    cd ..
    goto :eof
:: ________________________________________________________

:cleanRepo
    rem add any changes to stage for commit and push later 

    rem git add -A 2>nul || echo      -^> No staged changes to remove

    git clean -fdx 2>nul || echo nothing to clean 
    if %printouts%==True ( echo. & echo     ----------------------- & echo         -- CLEANED -- & echo        ----------------------- ) 


:: ________________________________________________________
:chkSubInfo
    rem remove all submodule refs 
    echo            ----------------------- current submodule config ------------------------
    echo. 
    echo -n | set /p=" .CONFIG"
    git config --get-regexp submodule 
    echo -n | set /p=" :STATUS"
    git submodule status
    echo. 
    goto :eof

:: ________________________________________________________


:verifyOriginLocalMatch

    rem check repo status and ensure clean 
    echo. 
    echo ___________________________ VERIFY REPO CLEAN ___________________________
    echo.
    echo            -^>  ORIGIN ^& LOCAL state NA if clean.
    echo. 
    echo -n | set /p="ORIGIN :"  & git config --get-regexp --show-origin submodule || echo          NA
    echo ------------------------------------------------------------
    echo -n | set /p="LOCAL :" & git config --get-regexp submodule || echo          NA
    echo.
    echo ____________________________________________________________________________
    echo. 
    goto :eof

:: ________________________________________________________

:clearStash
    git stash clear >nul || ( echo -- did not CLEAR stash ^!  -- )
    goto :eof

rem *********************************************************************************************
rem *******   winpy or py                            *******************************************
rem *********************************************************************************************

:find_py

    set flag=False
	rem Loop through each path in repoPATHs
	for %%P in (%pyPATHs%) do (
	    set "currentPath=%%~P\"

	    if exist "!currentPath!%exeName%" (
	        set flag=True 

	        set "PATH_PYTHON=!currentPath!"
	        set "PYTHON_EXE=!currentPath!%exeName%"

	        goto :found

	    ) else (
	         rem echo -n |set /p="... !currentPath!%exeName%...x"

	    )
	)

	if %flag% == False ( echo !pyType! not found. Install required... & where python & where WinPython & pause && exit /b )

	:found
	echo. 
	echo    -^> %pyType% found : !PATH_PYTHON! 
	goto :eof


:: ________________________________________________________

:setVenv

    set "venvPath_=%PATH_%%venvName%\" >nul || ( echo -- ERROR setting venv?  -- & pause & cmd /k)
    echo venv Path set -^> %venvPath_%
    goto :eof
:: ________________________________________________________________________________________________________________________________________


:chkVenv

    rem Ensure virtual environment exists if not det sys installs
    if exist %SETUP% ( echo VENV FOUND ---- & set "flagVenv=True" ) else ( echo NONE^. Freezing cw setup... & pause && exit /b ) 
    goto :eof

:: ________________________________________________________________________________________________________________________________________
                %= activate environment and move into working dir =% 
:actVenv

    rem Activate the virtual environment
    call %SETUP% || ( echo ERROR: Virtual environment activation FAIL^^! Attempt manual & cmd /k )

:: ________________________________________________________________________________________________________________________________________

:runFile

    rem user wants to debug -> enable cmd /k 
    if %debug% neq 0 ( 
        echo debuggin^^! 
        %pyPATHs% %repoPATHs%%file% || ( echo ERROR DEBUG: oh lets get it & cmd /k )
    )
    if %debug% == 0 ( 
        echo +ultra-mode...
        %pyPATHs% %repoPATHs%%file% || ( echo oh hell nah...try again & pause & goto :eof )
    )

rem *********************************************************************************************
rem *******   exit procedures                            ***************************************
rem *********************************************************************************************

:close

    rem closing procedures

    echo --------------^> CLOSING in %closetime% sec^! 



    for /L %%i in (%closetime%, -1, 1) do (
        rem <nul echo -n | set /p=%%i... 
        <nul set /p= CLOSING in %%i sec...
     
        timeout /nobreak /t 1 >nul
    )

    echo.
    echo -n | set /p=BYE^!

    endlocal
    deactivate
    rem exit from ALL connected and running scripts  
    exit 