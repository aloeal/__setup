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
set "BRANCH=development_2024"

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

:: Commit changes
echo Committing changes...?  
git commit -m "LFT -> updating origin" >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] No changes to commit.
) else (
    echo [OK] Commit successful.
)

:: Push to remote repository
echo Pushing to remote branch: %BRANCH%...
git push origin %BRANCH% >nul 2>&1
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
exit /b 0
