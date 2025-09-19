:: env_vars.bat written by Allie Christensen - July 20 2025

rem _________________________________________________________________________
rem CHANGE BELOW

rem repository information for the launcher to import 
set "repo=FSOTerminal"
set "branch=wasp2BlueSky"

rem potential repository paths
set repoPATHs="C:\OTTRepos" "C:\Users\fcomb\OTTRepos" "C:\Users\anc32\GitItUp" "C:\Users\fcomb\GitHub" "C:\GitHub" "C:\temp"

rem main python document ran to start gui
set "dir=camera_control\cameraprocess"
set "file=camera_processor_V1_2.py"



rem installtion information for system software 
set "pyType=WinPython"
set "pyVersion=3.9.4"
set pyPATHs="C:\Program Files\WPy64-3940" "C:\WinPy3.9.4\WPy64-3940\python-3.9.4.amd64" "C:\WPy64-3940\python-3.9.4.amd64"



rem _________________________________________________________________________
rem DO NOT CHANGE below

set "repoNames=%repo% %repo%-local %repo%-main"
set debug=0
set "loser=False"
set exeName=None

if /I %pyType%=="python" ( set exeName="python.exe" ) 
if %pyType%=="winpython" (set exeName="WinPython Command Prompt.exe" ) else ( set "exename=!pyType!" )

echo set exename
echo %exeName%


rem unused (for later) dynamic path
 
rem set "SETUP=%PATH_%%venvName%\Scripts\activate.bat" 
rem set "WORK_DIR=%PATH_%sysCode\camera_control\cameraprocess\"
rem set bonus="voidtools.Everything" "Microsoft.VCRedist.2013.x86"
rem set "venvName=__fsoVenv"
rem set "initBranch=freeSpaceOptics"
rem set "dir=_init"
rem set "initLink=https://github.com/aloeal/_flex.git"
rem set subs=__setup galvo_control
