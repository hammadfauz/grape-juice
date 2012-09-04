::Test Case File, It contains paths of all the scripts that we want to run as part of our test case
::Command Line Arguments received by this script
::Description of Argument					Representation of Argument in this script
::Path of AutoIT scripts					%1
::Name of the Test Case						%2

::Start of Script
@echo off
cd ..\scripts
echo Starting testcase.
echo Go have a cup of coffee.
echo Or play a game...
ping -n 5 127.0.0.1 >nul

echo Generating Pcap for fubar...
ping -n 5 127.0.0.1 >nul
anyapp.au3 -N %0 -t 60000


echo Test Complete.



