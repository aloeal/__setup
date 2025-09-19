:: env_vars.txt


set "repo=moomoo"

set "branch=itsGivingAlpha"
set "file=moosAintEddy.py"


set "pyType=python"
set "pyVersion=3.11.9"

#-------------------------------------------------
rem do hot change below unless avid user

set repoPATHs="C:\OTTRepos" "C:\Users\fcomb\OTTRepos" "C:\Users\anc32\GitItUp" "C:\Users\fcomb\GitHub" "C:\GitHub"  "C:\temp"

set "repoNames=%repo% %repo%-local %repo%-main"

set "venvName=__alphaVenv"
rem directory for the _flex submodules to be plopped
set "dir=__daddy"

set "subs=_flex"

#-------------------------------------------------

if /I %pyType%=="win" ( set pyPATHs="C:\Program Files\WPy*" "C:\Program Files\WinPy*" "C:\WinPy*" "C:\" 
) 
if /I %pyType%=="win" ( set pyPATHs="C:\Program Files\Py*" "C:\Program Files\py*" "C:\py*" "C:\" 
) 

else ( set pyPATHs="C:\Program Files\" "C:\users\" "C:\"  )

rem extra applications needing install
rem set bonus="voidtools.Everything" "Microsoft.VCRedist.2013.x86"