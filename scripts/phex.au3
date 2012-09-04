; Script Version: 1.0
;==Summary======================================
;run phex
;search for a file
;wait for results to appear
;download multiple results
;wait for specified time
;remove downloads
;close phex
;===============================================

#include <file.au3>
#include <Date.au3>
#include <..\DPI_UDF.au3>
#include <Math.au3>
#include <array.au3>

;Command Line Parameters
;=======================
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Note: Do NOT specify n,r as option switches,  ;;
;; it is used for testcase name, network scenario ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Default Values
Global $opt_t = 15000 ;time to capture in millisec
Global $opt_d = "timbaland" ; search term for download
;Reading Command Line arguments for variable initialization
Call("_ReadCmdLineParams", ":t:d")

;Local Variable Declarations
;===========================
;Commons but modify for each script
$AppPath = "C:\Program Files\Phex\" ;path of app executable
$AppProcess = "Phex.exe" ;needed for capture filter
$AppRuleName = 'gnutella' ;will be the name of the folder pcaps are stored in
;should be same as the name of the .rule file in STA
;others
$PhexTitle = "Phex"
$PhexWinhandle = ""
$TimeToRun = Number($opt_t)
$SearchTerm = $opt_d

;Common Start Routines
;=====================
Call("_CommonStartup",1)

;Script Actions
;==============
;Run Phex
$PhexWinHandle = Call("_LaunchApp", $AppPath & $AppProcess, $PhexTitle)
Sleep(1000)
;Call("_MaximizeWin",$PhexTitle)

;search for a file
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This is a java program, use "blind" mouse and keybd actions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Call('_MouseMoveNClick',$PhexTitle,"",145,95,"left")
Sleep(300)
Call('_MouseMoveNClick',$PhexTitle,"",50,210,"left")
Sleep(300)
Send($SearchTerm & "{ENTER}")
Call("_PauseUntilAreaChange",$PhexTitle,200,310,600,400)
;download multiple results
For $count = 0 To 10
	Call('_MouseMoveNClick',$PhexTitle,"",270,305+(20*$count),"left",2)
Next
Sleep(300)
Call('_MouseMoveNClick',$PhexTitle,"",220,95,"left")

;wait for specified time
Sleep($TimeToRun)

;remove downloads
For $count = 0 To 10
	Call('_MouseMoveNClick',$PhexTitle,"",30,170,"left")
	Sleep(100)
	Send("{DEL}")
	If WinExists("Remove Download") Then
		Send("{ENTER}")
	EndIf
Next

;close phex
;Call("_CloseWin",$soulSeekWinHandle)
Call("_CloseWin",$PhexTitle)
sleep(100)
ProcessClose($AppProcess)

;Common End Routines
;===================
Call("_CommonEnd")

Exit