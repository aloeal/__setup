
@echo off & setlocal enabledelayedexpansion


:startFunky

    call :openAdmin

    call :load_var

    call :find_repo

    call :find_py

    goto :eof

:: ________________________________________________________

:openAdmin
	rem Ensure script runs as administrator
	
	set "PATH_script=%~dp0"

	net session >nul 2>&1
	if %errorlevel% neq 0 (
	    echo Elevating privileges...
	    powershell -Command "Start-Process cmd -ArgumentList '/k cd /d ""%PATH_script%""' -Verb RunAs" && goto :eof
	)

:: ________________________________________________________

:load_var

    echo where env_vars.bat & cd 
    call env_vars.bat
    echo "      == RELOADED env_var.txt =="
    goto :eof

:: ________________________________________________________


:find_repo
    cd /d "%~dp0\..\..\.."
    set flag=False 
     
    :: Loop through each path in repoPATHs
    for %%P in (%repoPATHs%) do (
        set "currentPath=%%~P\"
        for %%Q in (!repoNames!) do (
            set "currentRepo=%%~Q\" 

     
            if exist "!currentPath!!currentRepo!" (

                set flag=True
                set "PATH_=!currentPath!!currentRepo!"
                echo -n |set /p="echo !currentPath!!currentRepo!\"

                goto :repoFound 


            ) else (
                echo -n |set /p="...!currentPath!!currentRepo!...x"  
            )
        )
    )



    if %flag% == False ( echo Initializing ERROR: Repo not found. & if !debug! ==1 ( echo debug me & cmd /k ) else ( pause & echo no debug & goto :eof )) 

    :repoFound
    echo. & echo    -^> REPO found : !PATH_! & echo. 
    goto :eof

:: ________________________________________________________

:find_py

set flag=False
	rem Loop through each path in repoPATHs
	for %%P in (%pyPATHs%) do (
	    set "currentPath=%%~P\"

	    if exist "!currentPath!%exeName%" (
	        set flag=True 

	        set "PATH_PYTHON=!currentPath!"
	        set "PYTHON_EXE=!currentPath!%exeName%"

	        goto :pythonFound

	    ) else (
	         rem echo -n |set /p="... !currentPath!%exeName%...x"

	    )
	)

	if %flag% == False ( where echo Python not found. Install required -^> & goto :decompressExe )

	:pythonFound
	echo. 
	echo    -^> PYTHON found : !PATH_PYTHON! 
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

:displayCwd

    echo -n | set /p=moved to.. current working dir: & cd
    goto :eof


:: ________________________________________________________

:clearStash
    git stash clear >nul || ( echo -- did not CLEAR stash ^!  -- )
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