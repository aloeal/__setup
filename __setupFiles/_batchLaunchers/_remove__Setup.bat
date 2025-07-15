:: ________________________________________________________________________________________________________________________________________
@echo off

rem  initial admin terminal start and dont remember variables -> messes with pc env


:: Ensure script runs as administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Elevating privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs -WindowStyle Normal" && exit /b
)

@echo off

:: so pc wont remember variables to enviroment
setlocal enabledelayedexpansion
cd /d "%~dp0\..\.."


:: ________________________________________________________________________________________________________________________________________

:: path to dirs (do not change)
rem set "repo=FSOTerminal"

:: potential repository paths
rem set repoPATHs="C:\OTTRepos" "C:\Users\fcomb\OTTRepos" "C:\Users\anc32\GitItUp" "C:\Users\fcomb\GitHub" "C:\temp"


rem set "repoNames=%repo% %repo%-local %repo%-main"
rem set "branch=cooked_2025"


rem set subs=__setup galvo_control

:: ________________________________________________________________________________________________________________________________________


set "pause=False"

set closetime=15 
rem units of seconds

set "dryRun=False"


set jub=False
set "skipFastAtt=False"
set "skipFastMod=False"
set "skipFastConfig=False"
set "printouts=True"
set /a flag=0

call :load_var

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
            if %pause% == True ( echo -n |set /p="!currentPath!!currentRepo!" )

            goto :repoFound 


        ) & rem else (  rem if %pause% == True ( rem ( echo -n |set /p="...!currentPath!!currentRepo!...x" )  & echo. ) )
    )
)


if %flagA% == False ( echo Initializing ERROR: Repo not found. & cmd /k )

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
git rm --q --f .gitattributes 2>nul || (  if !staged! ==False ( echo stage light please^!... ) ) 



:endloopAtt
rem remove from index 
git rm --cached .gitattributes 2>nul || ( if %staged% == %skipFastConfig% ( echo .gitattributes            ^| index removed ) ) 

rem reset global variables
set jub=False
set "staged=True"
:: ________________________________________________________________________________________________________________________________________

:rmGitMod

rem if file is staged -> git will not see or remove so add to remove .gitmodules 
if %skipFastMod% == "True" ( echo II^. & goto :rmGitConfig )

git diff --name-only --cached -- .gitmodules || ( set "staged=False" & echo set stage false )

rem when the file was not staged as opposed to an error 
git rm --q --f .gitmodules 2>nul || (  if !staged! ==False ( echo stage light please^!... ) ) 


:endloopMod
rem remove from index 
git rm --cached .gitmodules 2>nul || ( if %staged% == %skipFastConfig% ( echo .gitmodules          ^| index removed ) ) 

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

if %pause% == True ( pause )

( git config -f .git/config --unset submodule.active 2>nul && echo                                         -^> ^| Submodules INactive ) || echo ERROR Unsetting did not work OR no submodule to unset

:: ________________________________________________________________________________________________________________________________________


:clean

rem add any changes to stage for commit and push later 

rem git add -A 2>nul || echo      -^> No staged changes to remove

git clean -fdx 2>nul || echo nothing to clean 
if %printouts%==True ( echo. & echo     ----------------------- & echo         -- CLEANED -- & echo        ----------------------- ) 


:: ________________________________________________________________________________________________________________________________________

:commit

call :clearStash

if %pause% == True (  pause )

echo ------------------------------------------------------------

echo Dry run of commit and then commit stage...


if %dryRun% == True ( echo DRY-RUN mode - no real commit OR push going to close... & pause & goto :close )  

if %skipFastAtt% == True ( echo cestFin 3 & goto :skipAtt )
rem add all config and git changes to stage
git add .gitattributes 2>nul
git commit --dry-run -m "Updated .gitattributes -> remove lfs " || ( goto :skipAtt ) 
if %pause% == True ( echo ...ok to commit ^.gitattributes^? & pause ) else ( timeout /nobreak /t 1 2>nul ) 

git commit -m "Updated .gitattributes -> remove lfs "


:skipAtt
if %skipFastMod% == True (echo cestFin 2 &  goto :skipMod )
git add .gitmodules 2>nul 
git commit --dry-run -m "Updated .gitmodules -> remove submodule " || ( goto :skipMod ) 
if %pause% == True ( echo ...ok to commit ^.gitmodules^? & pause ) else ( timeout /nobreak /t 1 2>nul ) 

git commit -m "Updated .gitmodules -> remove submodule "


:skipMod
if %skipFastConfig% ==True (echo cestFin 1 )


rem commit the rest -> commits removal of submodules

for %%I in (%subs%) do ( 
    git diff --name-only --cached -- %%I || ( set "staged=False" & echo set stage false & git add %%I 2>nul )

    
    git commit --dry-run -am "Removing %%I submodule traces from branch"  

    if %pause% == True ( echo ...ok to commit rest^? & pause ) else ( timeout /nobreak /t 3 2>nul ) 

    git commit -am "Removing %%I submodule traces from branch" 
    ) 


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

rem :load_var

rem     call ".\__setup\__setupFiles\__files\env_vars.txt" || echo ERRO loading envvar
rem     echo "      == RELOADED env_var.txt =="
rem     exit /b

:load_var
    cd . 
    echo here
    cd 
    call .\__setupFiles\__files\env_vars.bat || (
        echo [ERROR] Failed to load env_vars.txt
        exit /b 1
    )
    echo [INFO] == Reloaded env_vars.txt ==
    exit /b

:clearStash
    git stash clear >nul || ( echo -- did not CLEAR stash ^!  -- )
    exit /b 



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