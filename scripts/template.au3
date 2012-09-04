; Script Version: 1.0
;==Summary======================================
;List here the actions your script will perform
;open SomeApp
;Do Something
;Then Something Else
;Close App
;===============================================
#include
#include
#include
#include
#include
#include
<file.au3>
<Date.au3>
<..\DPI_UDF.au3>
<Math.au3>
<array.au3>
<AC_AppClass_UDF.au3> ; sometimes you might need to define fucntions in a seperate UDF for re-use by other scri
;Command Line Parameters
;=======================
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Note: Do NOT specify n as option switch, ;;
;;
it is used for testcase name
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Default Values
Global $opt_a = "some default value" ;this will contain the value after -a switch on command line
Global $opt_b = "xyz" ;the value will be set to xyz, if no -b switch is supplied on command line
;Reading Command Line arguments for variable initialization
Call("_ReadCmdLineParams", ":a:b")

;Local Variable Declarations
;===========================
;Commons but modify for each script
$AppPath = "C:\Program Files\BitComet\" ;path of
$AppProcess = "BitComet.exe" ;needed for capture
$AppRuleName = 'bittorrent' ;will be the name of
;should be same as the name of the .rule file in
;others
$SomeVar=$opt_a
$AnotherVar=$opt_b
$OtherVar="value"
;Common Start Routines
;=====================
Call("_CommonStartup",1)
app executable
filter
the folder pcaps are stored in
STA
;give 1 if you want to capture using wireshark, else leave empty for ms netmonitor
;Script Actions
;==============
;open SomeApp
code for opening app
;Do Something
code for Do Something
;Then Something Else
code for Then Something Else
;Close App
code for Close App


