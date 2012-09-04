; Script Version: 1.2
;==Summary======================================
;This script expects user
;to execute and run app
;It will pause automation
;until user has done that
;IMP: Please set $AppRuleName and $AppProcess
;	  Before starting this script
;===============================================

#include <file.au3>
#include <Date.au3>
#include <..\DPI_UDF.au3>
#include <GUIConstantsEx.au3>
#include <Math.au3>
#include <array.au3>

;Command Line Parameters
;=======================
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Note: Do NOT specify n,r as option switches,  ;;
;; it is used for testcase name, network scenario ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Default Values

;Reading Command Line arguments for variable initialization
;Call("_ReadCmdLineParams", ":d:t")

;Local Variable Declarations
;===========================
;Commons but modify for each script
;$AppPath = "C:\Program Files\BitTorrent\" ;path of app executable
$AppProcess = "bitTorrent.exe" ;needed for capture filter
$AppRuleName = 'winny' ;will be the name of the folder pcaps are stored in
;should be same as the name of the .rule file in STA
;others
;$TimeToRun = $opt_t


;Common Start Routines
;=====================
Call("_CommonStartup",1)

;Script Actions
;==============
;Wait until user is done executing app
GUICreate("Research Automation",210,70)
GUICtrlCreateLabel("Run your application.",10,10,200)
GUICtrlCreateLabel("When you are done, Close this window.",10,25,200)
$Button=GUICtrlCreateButton("Close",10,40,100)
GUISetState()
While 1
    $msg = GUIGetMsg()
    Select
    Case $msg = $GUI_EVENT_CLOSE
        ExitLoop
    Case $msg = $Button
		WinClose("Research Automation")
    EndSelect
WEnd

;Common End Routines
;===================
Call("_CommonEnd")

Exit