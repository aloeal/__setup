these are bat file to run python scripts independent of spyder

python 3.8.9
"C:\WPy64-3890\python-3.8.9.amd64\python.exe"

python 2.7.10
'C:\Program Files\WinPython-64bit-2.7.10.3\python-2.7.10.amd64\python.exe'


To hide or minimize the window: -window hidden or -window minimized

@echo off
powershell -window hidden -command ""
cd C:\python\DCSCombControl\comb_box_temperature_control
"C:\WPy64-3890\python-3.8.9.amd64\python.exe" "C:\python\DCSCombControl\comb_box_temperature_control\comb_box_temperature_control.py"