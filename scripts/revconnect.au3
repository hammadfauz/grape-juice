; Script Version: 1.0
;==Summary======================================
;run revconnect
;wait for connect
;download random file lists
;wait for specified time
;close revconnect
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
;Reading Command Line arguments for variable initialization
Call("_ReadCmdLineParams", ":t")

;Local Variable Declarations
;===========================
;Commons but modify for each script
$AppPath = "C:\Program Files\RevConnect\" ;path of app executable
$AppProcess = "DCPlusPlus.exe" ;needed for capture filter
$AppRuleName = 'directconnect' ;will be the name of the folder pcaps are stored in
;should be same as the name of the .rule file in STA
;others
$DCTitle = "DC++ "
$DCWinHandle = ""
$TimeToRun = Number($opt_t)


;Common Start Routines
;=====================
Call("_CommonStartup",1)

;Script Actions
;==============
;Run DC++
$DCWinHandle = Call("_LaunchApp", $AppPath & $AppProcess, $DCTitle)
Sleep(2000)
Call("_MaximizeWin",$DCWinHandle)
;wait for connect
Call('_MouseMoveNClick',$DCWinHandle,"[CLASS:FlatTabCtrl; INSTANCE:1]",50,7,"left")
Sleep(1000)
Call("_PauseUntilControlChange",$DCWinHandle,"[CLASS:Edit; INSTANCE:1]")
Call("_PauseUntilControlChange",$DCWinHandle,"[CLASS:Edit; INSTANCE:1]")
;download random file lists
$DCRightTitle=WinGetTitle($DCWinHandle)
Sleep(500)
Call('_MouseMoveNClick',$DCWinHandle,"[CLASS:SysHeader32; INSTANCE:1]",130,10,"left")
Sleep(500)
Call('_MouseMoveNClick',$DCWinHandle,"[CLASS:SysHeader32; INSTANCE:1]",130,10,"left")
Sleep(500)
;put multiple results for download
For $count = 0 To 15
	If WinGetTitle($DCWinHandle) = $DCRightTitle Then
		Sleep(500)
	Else
		Call('_MouseMoveNClick',$DCWinHandle,"[CLASS:FlatTabCtrl; INSTANCE:1]",50,7,"left")
		Sleep(500)
	EndIf
	Call('_MouseMoveNClick',$DCWinHandle,"[CLASS:ATL:00502AC8; INSTANCE:1]",50,36+(20*$count),"",2)
	Sleep(500)
Next
;wait for specified time
Sleep($TimeToRun)
;Close DC++
;Call("_CloseWin",$soulSeekWinHandle)
ProcessClose($AppProcess)

;Common End Routines
;===================
Call("_CommonEnd")

Exit