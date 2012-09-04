; Script Version: 1.0
;==Summary======================================
;run manolito
;search for a file
;wait for results to appear
;download multiple results
;wait for specified time
;remove downloads
;close imesh
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
Global $opt_d = "timbaland" ;search term for download
;Reading Command Line arguments for variable initialization
Call("_ReadCmdLineParams", ":t:d")

;Local Variable Declarations
;===========================
;Commons but modify for each script
$AppPath = "C:\Program Files\Manolito\" ;path of app executable
$AppProcess = "Manolito.exe" ;needed for capture filter
$AppRuleName = 'manolito' ;will be the name of the folder pcaps are stored in
;should be same as the name of the .rule file in STA
;others
$ManolitoTitle = " Manolito "
$ManolitoWinHandle = ""
$TimeToRun = Number($opt_t)
$SearchTerm = $opt_d

;Common Start Routines
;=====================
Call("_CommonStartup",1)

;Script Actions
;==============
;Run imesh
$ManolitoWinHandle = Call("_LaunchApp", $AppPath & $AppProcess, $ManolitoTitle,@ScriptDir,20)
ConsoleWrite($AppPath & $AppProcess)
Sleep(1000)
;Call("_MaximizeWin",$ManolitoTitle)

;search for a file
Call('_MouseMoveNClick',$ManolitoTitle,"[CLASS:ToolbarWindow32; INSTANCE:1]",200,25,"left")
Sleep(300)
ControlSend($ManolitoTitle,"","[CLASS:Edit; INSTANCE:2]","{CTRLDOWN}a{CTRLUP}" & $SearchTerm & "{ENTER}")
Sleep(2000)

;download multiple results
For $count = 0 To 10
	Call('_MouseMoveNClick',$ManolitoTitle,"[CLASS:ThunderRT6UserControlDC; INSTANCE:45]",53,29+(20*$count),"left",2)
Next

;wait for specified time
Call('_MouseMoveNClick',$ManolitoTitle,"[CLASS:ToolbarWindow32; INSTANCE:1]",280,25,"left")
Sleep($TimeToRun)

;remove downloads
For $count = 0 To 10
	Call('_MouseMoveNClick',$ManolitoTitle,"[CLASS:ThunderRT6UserControlDC; INSTANCE:19]",60,30,"left")
	Sleep(100)
	Send("{DEL}")
	If WinExists("[CLASS:#32770]") Then
		Call('_MouseMoveNClick',"[CLASS:#32770]","[CLASS:Button; INSTANCE:1]",35,10,"left")
	EndIf
Next

;close imesh
;Call("_CloseWin",$soulSeekWinHandle)
sleep(100)
ProcessClose($AppProcess)

;Common End Routines
;===================
Call("_CommonEnd")

Exit