:: Batch file to commit and push files > 100 MB to github using git-lfs
:: NOTE: git bash and git-lfs must be installed to run 

:: ________________________________________________________________________________________________________________________________________

:: Ensure script runs as administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Elevating privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs -WindowStyle Normal" && exit /b
)

@echo off
setlocal enabledelayedexpansion

:: Define the branch name
set "BRANCH=freeSpaceOptics" ||  ( set "BRANCH=TEST_blue" ) 

echo.
echo ================================
echo   Git LFS Push Script Started
echo ================================
echo.

:: Check if Git is installed
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Git is not installed. Install Git and try again.
    pause
    exit /b 1
)

:: Check if Git LFS is installed
git lfs version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Git LFS is not installed. Install Git LFS and try again.
    pause
    exit /b 1
)

:: Navigate to the repository folder (modify if needed)
cd /d "%~dp0"

:: Initialize Git LFS if not already initialized
echo Initializing Git LFS...
git lfs install >nul 2>&1
echo [OK] Git LFS initialized.

:: Track large file types (modify as needed)
echo Configuring Git LFS tracking...
git lfs track "*.bin" "*.zip" "*.tar.gz" "*.iso" "*.exe" 2>&1
echo [OK] Git LFS tracking set.

:: Checkout the branch
echo Switching to branch: %BRANCH%...
git checkout %BRANCH% >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Branch '%BRANCH%' not found. Make sure it exists.
    pause
    exit /b 1
)
echo [OK] Now on branch '%BRANCH%'.

:: Add all changes
echo Staging files...
git add . >nul 2>&1
echo [OK] Files staged.

:: display changes to be made in commit
rem git diff --cached
git commit --dry-run --verbose
git lfs push --dry-run origin %BRANCH%

rem git push --dry-run
echo dry run git push ------  

:: Commit changes
echo Commit ^& push changes...? & set /p answer="Answer (y/n):"

if /i !answer! == y ( echo YAS please^^! & goto :commitLFS)
if /i !answer! neq y (
    echo -n |set /p=meow no last jubbie^!
    if /i !answer! neq n ( echo "ERROR lastjubba: Please only enter" & pause & goto :lastjubba )
    )
if /i !answer! == n ( echo __setup done^! & exit )


:commitLFS
git commit -m "LFT -> updating origin" >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] No changes to commit.
) else (
    echo [OK] Commit successful.
)

:: Push to remote repository
echo Pushing to remote branch: %BRANCH%...
git lfs push --all origin %BRANCH% >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Push failed. Check your Git settings.
    pause
    exit /b 1
)
echo [OK] Push successful.

echo.
echo ================================
echo   Git LFS Push Completed
echo ================================
echo.

pause
endlocal
exit 
