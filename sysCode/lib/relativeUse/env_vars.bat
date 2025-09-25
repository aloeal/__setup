:: env_vars.bat written by Allie Christensen - July 20 2025

rem _________________________________________________________________________
rem CHANGE BELOW

rem repository information for the launcher to import 
set "repo=mooMoo"
set "branch=main"

rem potential repository paths
set repoPATHs="C:\OTTRepos" "C:\Users\fcomb\OTTRepos" "C:\Users\anc32\GitItUp" "C:\Users\fcomb\GitHub" "C:\GitHub" "C:\temp" "C:\"

rem main python document ran to start gui
set "dir=sysCode\"
set "file=agNext_Gen.py"


rem installtion information for system software 
set "pyType=python"
set "pyVersion=3.8"
rem set pyPATHs="C:\Program Files\WPy64-3940" "C:\WinPy3.9.4\WPy64-3940\python-3.9.4.amd64" "C:\WPy64-3940\python-3.9.4.amd64"
set pyPATHs="C:\Program Files\" "C:\" "C:\Users\fcomb\" "C:\Users\anc32\" 


set skipPython=0

rem _________________________________________________________________________
rem DO NOT CHANGE below

set +ultra=True & rem fastest setup method

set debug=0




rem to install git bash into repo 
set skipGit=0

rem below skips need to uncompress bonus and/or exe files 
set skipExe=1

rem whether to skip .exe or uncompressed files in __files 
set skipBonus=1
rem _________________________________________________________________________


if %skipPython%==0 ( set skipVenv=0 ) else ( set skipVenv=1 )
if %+ultra%==True ( set ask=0 ) else ( set ask=1)

set closetime=30 & rem units OF SECONDS
set waittime=3
set "loser=False"
set "flagVenv=False"

set exeName=None


set "repoNames=%repo% %repo%-local %repo%-main"

if /I %pyType%=="winpython" (set exeName="WinPython Command Prompt.exe" )
if /I %pyType%=="python" ( set exeName="python.exe" ) else ( echo !pyType! & set "exename=!pyType!.exe" )
echo set exename
echo %exeName%


rem # python-3.8.10-amd64.exe
set bonus="voidtools.Everything" 
set bonus1="eddypro-7.0.9"

set bonus=2
set "venvName=__mooVenv"
set "flexDir=_init"
set "initLink=https://github.com/aloeal/_flex.git"
rem below checked for removal
set subs=__setup
 
set "SETUP=%PATH_%%venvName%\Scripts\activate.bat" 
set "WORK_DIR=%PATH_%%dir%%flexDir%"


goto :eof