
@echo off & setlocal enabledelayedexpansion 
%= above line = MUST have pc not remember variables to enviroment DO NOT REMOVE =% 


:: ________________________________________________________________________________________________________________________________________
        %= output script information to terminal for user  =% 


if %loser%==True ( goto :initilization ) else ( echo testing intro... )


echo -- aloeBrooks automated submodule _flex debugger file -- 
echo Last mod: Sep 15 2025
echo Created by: Allie Christensen Brooks

:: ________________________________________________________________________________________________________________________________________
:: ________________________________________________________________________________________________________________________________________
        %= ensure prop dir and load files needed to setup software in __setupFiles =% 

:initilization

echo ****************** & echo starting up... & echo ******************

cd /d "%~dp0\..\.." & call :displayCwd

if  %loser%==True ( echo loserville ) else ( echo its giving our great trimphed czar & pause )

rem *********************************************************************************************
        %= import funks.bat and requirements.txt and env_vars.txt =% 


rem load file with batch functions to initalize terminal operation and repo location
call :load_funks | echo ERROR loading funkies oh no!

rem run funks.bat to set repo location PATH_ and respectively python or winpython path 
call :startFunky

if  %loser%==True ( goto :startBat ) else ( echo "Your a winner chckn dinner, env comming in hot" & pause )
:: ________________________________________________________________________________________________________________________________________


set closetime=15 
rem units of seconds

set "dryRun=False"



:: ________________________________________________________________________________________________________________________________________
set jub=False
set "skipFastAtt=False"
set "skipFastMod=False"
set "skipFastConfig=False"
set "printouts=True"
set /a flag=0
:: ________________________________________________________________________________________________________________________________________

rem find repo and save location 

set flagA=False 
 
:: Loop through each path in repoPATHs
for %%P in (%repoPATHs%) do (
    set "currentPath=%%~P\"
    for %%Q in (!repoNames!) do (
        set "currentRepo=%%~Q\" 

 
        if exist "!currentPath!!currentRepo!" (

            set flagA=True
            set "PATH_=!currentPath!!currentRepo!"
            if %debug% == True ( echo -n |set /p="!currentPath!!currentRepo!" )

            goto :repoFound 


        ) & rem else (  rem if %debug% == True ( rem ( echo -n |set /p="...!currentPath!!currentRepo!...x" )  & echo. ) )
    )
)


if %flagA% == False ( echo Initializing ERROR: Repo not found. & if !debug! ==1 ( echo debug me & cmd /k ) else ( pause & echo no debug & exit /b )) 


:: ________________________________________________________________________________________________________________________________________

:repoFound

rem into to user
echo.
echo.
echo ___________________________ GIT repo config submodule removal ___________________________________
echo.
echo    -^> REPO : !PATH_! 
echo _________________________________________________________________________________________________
echo.

cd %PATH_% >nul
git switch %branch% >nul
git pull >nul

call :clearStash

:: ________________________________________________________________________________________________________________________________________


if not EXIST .gitattributes ( set "skipFastAtt=True" & echo .GITATT ^| done ) 
if not EXIST .gitmodules ( set "skipFastMod=True" & echo .GITMOD ^| done ) 
( git config --get-regexp submodule 2>nul && git submodule status 2>nul ) || ( set "skipFastConfig=True" & echo .config ^| done ) 

rem to skip config 
if %skipFastConfig% == True ( 
    echo LIGHTSPEED^!
    rem to skip .gitmod & .gitatt -> clean & to skip .gitmod 
    if %skipFastMod% == True ( if %skipFastAtt% == True ( set "printouts=False" & goto :clean )
    ) else ( if %skipFastAtt% == True ( call :intro & echo II^. & goto :rmGitMod ) else  ( echo NO skip just CONFIG ) )
    rem to skip .gitatt -> clean & to skip .gitmod 
) 


:: ________________________________________________________________________________________________________________________________________
echo I^.
call :intro

:: ________________________________________________________________________________________________________________________________________


:rmGitAtt


rem delete large file storage since no longer used -> stored in attributes (.gitattributes) 
set "staged=True"


git diff --name-only --cached -- .gitattributes || ( set "staged=False" & echo set stage false )

rem when the file was not staged as opposed to an error 
git rm --q --f .gitattributes 2>nul || ( 
    if !staged! ==False ( echo stage light please^!... 
    ) else ( echo ERROR rm ^.gitattributes ) 
)



:endloopAtt
rem remove from index 
git rm --cached .gitattributes 2>nul || ( if %staged% == %skipFastConfig% ( echo .gitattributes            ^| index removed ) else ( echo ERROR .gitattributes cache )) 

rem reset global variables
set jub=False
set "staged=True"
:: ________________________________________________________________________________________________________________________________________

:rmGitMod

rem if file is staged -> git will not see or remove so add to remove .gitmodules 
if %skipFastMod% == "True" ( echo II^. & goto :rmGitConfig )

git diff --name-only --cached -- .gitmodules || ( set "staged=False" & echo set stage false )

rem when the file was not staged as opposed to an error 
( git rm --q --f .gitmodules 2>nul && echo .gitmodules          ^| index removed ) || ( echo ERROR rm ^.gitmodules & pause )


:endloopMod
rem remove from index 
git rm --cached .gitmodules 2>nul || ( if %staged% == %skipFastConfig% ( echo .gitmodules          ^| index removed ) else ( echo ERROR .gitmodules cache ) ) 

rem reset global variables
set jub=False
set "staged=True"

:: ________________________________________________________________________________________________________________________________________

:rmGitConfig

rem echo Deinitializing submodules ... 

if %skipFastConfig% == True ( echo III^. & goto :clean )

git submodule deinit -f --all 2>nul || ( echo      -^> Submodule already deinitialized )

for %%I in (%subs%) do ( 

    git update-index --force-remove -- %%I 2>nul|| ( echo      -^> No lingering index entry found )

    git config --remove-section submodule.%%I 2>nul || ( echo      -^> No submodule^.%%I section found )

    git rm -rf --cached %%I 2>nul || ( echo      -^> No cache to remove )

    IF EXIST .git\modules\%%I ( set /a flag+=1 & echo found %%I inside ^.git^\modules... submodule #!flag! )
    )


if %flag% GTR 0 (  rmdir /S /Q .git\modules & set flag=0 || ( echo      -^> Unable to delete module within ^.git )  )

if %debug% == True ( pause )

( git config -f .git/config --unset submodule.active 2>nul && echo                                         -^> ^| Submodules INactive ) || echo ERROR Unsetting did not work OR no submodule to unset

:: ________________________________________________________________________________________________________________________________________


:clean

rem add any changes to stage for commit and push later 

rem git add -A 2>nul || echo      -^> No staged changes to remove

git clean -fdx 2>nul || echo nothing to clean 
if %printouts%==True ( echo. & echo     ----------------------- & echo         -- CLEANED -- & echo        ----------------------- ) 


:: ________________________________________________________________________________________________________________________________________

:commit

echo ------------------------------------------------------------

call :clearStash

if %debug% == True (  pause )

echo ------------------------------------------------------------


if %dryRun% == True ( echo DRY-RUN mode - no real commit OR push going to close... & pause & goto :close )  

if %skipFastAtt% == True ( echo cestFin 3 & goto :skipAtt )
echo ------------------------------------------------------------


rem add all config and git changes to stage
git add .gitattributes 2>nul

git commit --dry-run -m "Updated .gitattributes -> remove lfs " || ( goto :skipAtt ) 
if %debug% == True ( echo ...ok to commit ^.gitattributes^? & pause ) else ( timeout /nobreak /t 1 2>nul ) 

git commit -m "Updated .gitattributes -> remove lfs "

echo ------------------------------------------------------------

:skipAtt

if %skipFastMod% == True (echo cestFin 2 &  goto :skipMod )
git add .gitmodules 2>nul 

git commit --dry-run -m "Updated .gitmodules -> remove submodule " || ( goto :skipMod ) 
if %debug% == True ( echo ...ok to commit ^.gitmodules^? & pause ) else ( timeout /nobreak /t 1 2>nul ) 

git commit -m "Updated .gitmodules -> remove submodule "

echo ------------------------------------------------------------

:skipMod

rem commit the rest -> commits removal of submodules
for %%I in (%subs%) do ( 
    git diff --name-only --cached -- %%I || ( set "staged=False" & echo set stage false & git add %%I 2>nul )


    git commit --dry-run -am "Removing %%I submodule traces from branch"  || ( goto :cestFin ) 

    if %debug% == True ( echo ...ok to commit rest^? & pause ) else ( timeout /nobreak /t 1 2>nul ) 

    git commit -m "Removing %%I submodule traces from branch" 
    ) 

if %skipFastConfig% ==True (echo cestFin 1 )




echo ------------------------------------------------------------
:: ________________________________________________________________________________________________________________________________________

:cestFin

echo _________________________________________________________________________________________________
echo                                        C'est Fin
echo _________________________________________________________________________________________________
echo.
git submodule status 2>nul || ( echo       ^| verified ^|  )

echo _________________________________________________________________________________________________

goto :close 


:: ________________________________________________________________________________________________________________________________________

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
    exit

:: ________________________________________________________________________________________________________________________________________


:verify

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
    echo. & exit /b 


:intro
    rem remove all submodule refs 
    echo            ----------------------- current config ------------------------
    echo. 
    echo -n | set /p=" .CONFIG"
    git config --get-regexp submodule 
    echo -n | set /p=" :STATUS"
    git submodule status
    echo. 
    echo            -------------------- adjusting config ... ---------------------
    exit /b


:load_var
    cd . 
    echo here
    cd 
    call .\__setupFiles\__files\env_vars.bat || (
        echo [ERROR] Failed to load env_vars.bat
        exit /b 
    )
    echo [INFO] == Reloaded env_vars.txt ==
    exit /b


:load_funks
    cd . 
    echo here
    cd 
    call .\__setupFiles\_batch\.relativeUse\funks.bat || (
        echo [ERROR] Failed to load funks.bat
        exit /b 
    )
    echo [INFO] == Reloaded funks.bat ==
    exit /b

:clearStash
    git stash clear >nul || ( echo -- did not CLEAR stash ^!  -- )
    exit /b 

:: ________________________________________________________________________________________________________________________________________
