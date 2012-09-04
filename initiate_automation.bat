@echo off
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::Arguments:	test case name (without the .bat extension)
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


::To remove conflicts with other dos terminals
TITLE Grape Juice Automation Platform

set AUTOMATION_DIR=%CD%

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::Set the Variables below in accordance with your current test machine
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::Name of the Test Case file, Test case script should be present in testcases directory as this script.
set TEST_CASE_FILE=%1

::Name of Folder in which AutoIT scripts are present, the folder should in same path as this script file.
set AUTO_IT_SCRIPTS_DIR=scripts

::Name of the Folder you want the final pcaps in
set FINAL_DIR=C:\pcaps\

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::Donot Change anything below this line Unless you want to modify the script
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

cd %AUTOMATION_DIR%
echo Running Test case titled %TEST_CASE_FILE%...
cd testcases\
call %TEST_CASE_FILE%
ping -n 10 127.0.0.1 >nul
echo Test Case Complete...

echo Copying Pcaps from this machine to final directory...
cd %AUTOMATION_DIR%\output\%TEST_CASE_FILE%\pcaps\
del /S *.cap >nul
xcopy /S %AUTOMATION_DIR%\output\%TEST_CASE_FILE%\pcaps\ %FINAL_PATH%\%TEST_CASE_FILE%
ping -n 10 127.0.0.1 >nul
echo Copying Complete...
echo Exiting...