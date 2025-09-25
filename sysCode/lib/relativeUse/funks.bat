
@echo off & setlocal enableExtensions enabledelayedexpansion
rem below label, _init, runs ALWAYS when batch file is called/ran/compiled
echo starting ...

:_init
    echo hello
    set "parent=%~1"
    echo %~1
    call :load_var

    call :showCWD

    call :helloScript
     
    rem catch the call case settings 
    rem -> if main launcher, python file and main compile 
    rem -> if _flex, installs and venv
    echo file calling funks.bat ^> %parent% & pause 
    if "%parent%"=="%file%" ( echo alpha & goto :startAlpha) else ( echo funny & call :startFunky)
    exit /b



:startFunky
    echo funky alpha
    pause

    rem look for repository cloned ontol pc using generalized paths in env_var.bat
    call :findDir
    echo funky beta
    rem CHANGE ME if needing to switch dir 
    rem call :switchGitPull
    echo funky charlie
    pause
    rem look for pyType installed on pc or install 
    call :find_py
    echo 
    pause
    rem set requested venv path as variable for parent batch
    call :startAlpha
    echo funky delta
    pause
    rem belows essentially returns code back to file that called originally
    exit /b 

:startAlpha
    echo start alpha & pause

    rem determine if venv exists or needs creation
    call :setVenv
    
    call :chkVenv
    echo funky epsilon
    pause
    call :actVenv
    echo funky freddy
    pause
    call :createVenv
    rem belows essentially returns code back to file that called originally
    exit /b


    
rem *********************************************************************************************
rem *******   sys & user                             *******************************************
rem *********************************************************************************************

:showCWD
    echo CWD:
    cd 
    exit /b
   


:openAdmin
	rem Ensure script runs as administrator
	
	set "PATH_script=%~dp0\..\.."

	net session >nul 2>&1
	if %errorlevel% neq 0 (
	    echo Elevating privileges...
	    powershell -Command "Start-Process cmd -ArgumentList '/k cd /d ""%PATH_script%""' -Verb RunAs" 
	)
    goto :eof






:load_var

    echo where env_vars.bat 
    cd
     
    call "./__setupFiles/_batchLaunchers/relativeUse/env_vars.bat" || (
        echo [ERROR] Failed to load env_vars.bat
        pause
    )
    echo "      == LOADED env_var =="
    exit /b

:: ________________________________________________________

:displayCwd

    echo -n | set /p=moved to.. current working dir: & cd
    exit /b

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
        exit /b 

    :resultTrue
        rem update user with choosen installs avaliable versions
        echo result true
        exit /b

    :resultOther
        rem reroute user back to question if answer is invalid
        echo ERROR: Invalid input. Please enter "w" or "p". Please try again^.
        exit /b


rem *********************************************************************************************
rem *******   data or git                            *******************************************
rem *********************************************************************************************
rem Loop through each path in repoPATHs


:findDir

    set "flag=False" 
    set "FOUND_PATH="
    echo searching for dir...
    echo from %repoPATHs%...
    for %%P in (%repoPATHs%) do (
        echo jam
        set "currentPath=%%~P\"
        echo !currentPath!

        for %%Q in (%repoNames%) do (

            set "currentRepo=%%~Q\" 

            echo jub
            echo !currentRepo!

            if exist "!currentPath!!currentRepo!" (

                set "flag=True"
                set "FOUND_PATH=!currentPath!!currentRepo!"
                echo -n |set /p="echo !currentPath!!currentRepo!"

                goto :repoFound 
            ) else ( 
                echo -n |set /p="...!currentPath!!currentRepo!...x"   
            )
        )
     )



    if /I %flag% == False ( 
        echo Initializing ERROR: Repo not found. 
        if %debug% ==1 ( echo debug me & cmd /k ) else ( pause & echo no debug & exit /b )
    ) 

    :repoFound
    echo. & echo    -^> REPO found : !PATH_! & echo. 
    set "PATH_=!FOUND_PATH!"
    exit /b
:: ________________________________________________________

:switchGitPull
    if %PATH_% neq %cd% (
        cd %PATH_% >nul || ( echo bad %PATH_% & pause )
        call :displayCwd
    )
    
    git switch %branch% >nul || ( 
        echo ERROR %errorlevel% : 
        
        echo ERROR: GIT switch, may already be on correct branch... 
        
        git status 
    )
    echo confirm pull? & pause
    call :askQ "Confirm pull of %repo%/%branch%" "y" "n" || ( echo error ASKQ & exit /b )
    git pull >nul || ( echo bad pull & pause )
    exit /b 
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
    exit /b
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
    exit /b

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
    exit /b

:: ________________________________________________________

:clearStash
    git stash clear >nul || ( echo -- did not CLEAR stash ^!  -- )
    exit /b

rem *********************************************************************************************
rem *******   winpy or py                            *******************************************
rem *********************************************************************************************

:find_py
    echo finding py...
     
    set "flag=False"
    set "FOUND_PATH="
    set "PYTHON_EXE="
    
    echo %pyPATHs%
    echo %exeName%
    pause 

	for %%P in (%pyPATHs%) do (
        echo !currentPath!%exeName%

	    set "currentPath=%%~P"
        pause 
       
   	    if exist "!currentPath!%exeName%" (
            echo found 
	        set "flag=True"

	        set "FOUND_PATH=!currentPath!"
	        set "PYTHON_EXE=!currentPath!%exeName%"

	        goto :found

        ) else ( pause & echo -n |set /p="... !currentPath!%exeName%...x" )  
	)

	if /I %flag% == False ( 
        echo %pyType% not found. Install required... 
        pause 
        exit /b 
    )

	:found
	echo. 
    set "PATH_PYTHON=!FOUND_PATH!"
	echo    -^> %pyType% found : !PATH_PYTHON! 
	exit /b


:: ________________________________________________________

:setVenv

    set "venvPath_=%PATH_%%venvName%\" >nul || ( echo -- ERROR setting venv?  -- & pause & cmd /k)
    echo venv Path set -^> %venvPath_%
    set "PATH_PYTHON=!FOUND_PATH!"

    exit /b
:: ________________________________________________________________________________________________________________________________________


:chkVenv

    rem Ensure virtual environment exists if not det sys installs
    if exist %SETUP% ( echo VENV FOUND ---- & set "flagVenv=True" ) else ( echo NONE^. Freezing cw setup... & pause && exit /b ) 
    exit /b
:: ________________________________________________________________________________________________________________________________________

:createVenv
    rem new venv creation
    "%PYTHON_EXE%" -m venv %venvPath_% --prompt %venvName% 2>&1 || ( echo ERRORa !errorlevel!: Attempted to make env. && if %debug% == 1 ( echo Enabling cmd... && echo Ready! & cmd /k ) else ( echo oopsie & call :close ) )
    rem if %debug% == 0 ( echo NOT in DEBUG MODE... & echo -n | ping -n 10 127.0.0.1 >nul && echo moving on! )
    echo -n | set /p="Fresh venv created! "
    exit /b

:: ________________________________________________________________________________________________________________________________________
                %= activate environment and move into working dir =% 
:actVenv

    rem Activate the virtual environment
    call %SETUP% || ( echo ERROR: Virtual environment activation FAIL^^! Attempt manual & cmd /k )
    exit /b
:: ________________________________________________________________________________________________________________________________________

:runFile

    rem user wants to debug -> enable cmd /k 
    if %debug% neq 0 ( 
        echo debuggin^^! 
        %pyPATHs% %repoPATHs%%file% || ( echo ERROR DEBUG: oh lets get it & cmd /k )
    )
    if %debug% == 0 ( 
        echo +ultra-mode...
        %pyPATHs% %repoPATHs%%file% || ( echo oh hell nah...try again & pause & exit /b )
    )




rem *********************************************************************************************
rem *******   exit procedures                            ***************************************
rem *********************************************************************************************


:: ________________________________________________________


:helloScript
    echo -- aloeBrooks %repo% %branch%  -- Last mod: Sep 22 2025
    exit /b

:helloSoftware
    set "title=%~1"
    set "lastMod=%~2"
    echo -- %title% -- Last mod: %lastMod%
    exit /b

:: ________________________________________________________

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