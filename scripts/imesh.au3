; Script Version: 1.0
;==Summary======================================
;run imesh
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
Global $opt_d = "timbaland"	;search term for download
;Reading Command Line arguments for variable initialization
Call("_ReadCmdLineParams", ":t:d")

;Local Variable Declarations===================
;Commons but modify for each script
$AppPath = "C:\Program Files\iMesh Applications\iMesh\" ;path of app executable
$AppProcess = "iMesh.exe" ;needed for capture filter
$AppRuleName = 'imesh' ;will be the name of the folder pcaps are stored in
;should be same as the name of the .rule file in STA
;others
$ImeshTitle = "[CLASS:iMesh_MainWnd]"
$ImeshTitle2 = "[CLASS:{22A392FB-5469-4fad-809B-726157B615AC}]"
$ImeshWinHandle = ""
$TimeToRun = Number($opt_t)
$SearchTerm = $opt_d

;Common Start Routines
;=====================
Call("_CommonStartup",1)

;Script Actions
;==============
;Run imesh
$ImeshWinHandle = Call("_LaunchApp", $AppPath & $AppProcess, $ImeshTitle,@ScriptDir,20)
Sleep(1000)
;Call("_MaximizeWin",$ImeshTitle)

;search for a file
$redo=1
While $redo=1
	Call('_MouseMoveNClick',$ImeshTitle2,"[CLASS:Button; INSTANCE:3]",40,10,"left")
	Sleep(300)
	ControlSend($ImeshTitle2,"","[CLASS:Edit; INSTANCE:3]","{CTRLDOWN}a{CTRLUP}" & $SearchTerm & "{ENTER}")
	Sleep(300)
	If WinExists("[CLASS:#32770]") Then
		Call('_MouseMoveNClick',"[CLASS:#32770]","[CLASS:Button; INSTANCE:4]",40,10,"left")
		$redo=1
	Else
		$redo=0
	EndIf
WEnd
Sleep(10000)
Call('_MouseMoveNClick',$ImeshTitle2,"",20+18,10+74,"left")
sleep(300)
Call('_MouseMoveNClick',$ImeshTitle2,"",244+14,10+100,"left")
sleep(300)
Call('_MouseMoveNClick',$ImeshTitle2,"",244+14,10+100,"left")

;download multiple results
For $count = 0 To 10
	Call('_MouseMoveNClick',$ImeshTitle2,"",45+14,35+100+(20*$count),"left",2)
Next

;wait for specified time
Sleep($TimeToRun)

;remove downloads
For $count = 0 To 10
	Call('_MouseMoveNClick',$ImeshTitle2,"",45+15,35+470,"left")
	Sleep(100)
	Send("{DEL}")
	If WinExists("[CLASS:#32770]") Then
		Call('_MouseMoveNClick',"[CLASS:#32770]","[CLASS:Button; INSTANCE:4]",35,10,"left")
	EndIf
Next

;close imesh
;Call("_CloseWin",$soulSeekWinHandle)
;Call("_CloseWin",$ImeshTitle)
sleep(100)
ProcessClose($AppProcess)

;Common End Routines
;===================
Call("_CommonEnd")

Exit