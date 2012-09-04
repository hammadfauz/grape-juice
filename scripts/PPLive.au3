; Script Version: 1.1
;==Summary======================================
;Launch PPLive
;Stream random vids
;Exit
;===============================================

#include <Clipboard.au3>
#include <file.au3>
#include <IE.au3>
#include <Math.au3>
#include <Date.au3>
#include <..\DPI_UDF.au3>
#include <array.au3>

;Command Line Parameters
;=======================
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Note: Do NOT specify n,r as option switches,  ;;
;; it is used for testcase name, network scenario ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Default Values
Global $opt_t=15000	;time to capture in millisec
;Reading Command Line arguments for variable initialization
Call("_ReadCmdLineParams",":t")

;Local Variable Declarations
;===========================
;Commons but modify for each script
$AppPath = "C:\Program Files\PPLive\PPTV\" ;path of app executable
$AppProcess = "PPLive.exe"
$AppRuleName='pplive'	;will be the name of the folder pcaps are stored in
						;should be same as the name of the .rule file in STA
;others
$PPLiveTitle="[Class:PPLiveGUI]"
$PPLiveTitle2="[Class:PPGuiFoundation]"
$PPLiveWinHandle=""
$TimeToRun=Number($opt_t)

;Common Start Routines
;=====================
Call("_CommonStartup")

;Script Actions
;==============
;Launch PPLive
local $Return_Value[2]
Opt("WinTitleMatchMode",2)
$PPLiveWinHandle=Call("_LaunchApp",$AppPath & $AppProcess,$PPLiveTitle)
sleep(2000)
Opt("WinTitleMatchMode",1)
WinMove($PPLiveTitle,"",300,"",1090,606)
Sleep(1000)
;Stream random vids
Call("_MouseMoveNClick",$PPLiveTitle,"[CLASS:MFCReportCtrl; INSTANCE:2]",50,10)
Call("_MouseMoveNClick",$PPLiveTitle,"[CLASS:MFCReportCtrl; INSTANCE:2]",50,30)
Call("_MouseMoveNClick",$PPLiveTitle,"[CLASS:MFCReportCtrl; INSTANCE:2]",50,50)
Call("_MouseMoveNClick",$PPLiveTitle,"[CLASS:MFCReportCtrl; INSTANCE:2]",50,70)
Sleep(15000)
Call("_MouseMoveNClick",$PPLiveTitle,"[CLASS:MFCReportCtrl; INSTANCE:2]",-50,280)
Call("_MouseMoveNClick",$PPLiveTitle,"[CLASS:MFCReportCtrl; INSTANCE:2]",-100,280)
Sleep($TimeToRun)
;Exit
ProcessClose($AppProcess)
ProcessClose("PPAP.exe")

;Common End Routines
;===================
Call("_CommonEnd")

exit