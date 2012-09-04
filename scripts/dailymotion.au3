;==Summary======================================
;Run Google Chrome and open dailymotion
;Close Google Chrome
;===============================================

#Include <Clipboard.au3>
#include <file.au3>
#include <..\DPI_UDF.au3>
#include <AC_web_UDF.au3>
#include <array.au3>
#include <Math.au3>

;Command Line Parameters
;=======================
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Note: Do NOT specify n,r as option switches,  ;;
;; it is used for testcase name, network scenario ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Default Values
Global $opt_s = "science experiments"	;video to search for
Global $opt_t = 30000			;time to capture in millisec
;Reading Command Line arguments for variable initialization
Call("_ReadCmdLineParams", ":s:t")

;Local Variable Declarations
;===========================
;Commons but modify for each script
$AppProcess="chrome.exe"	;needed for capture filter
$AppRuleName='flash'		;will be the name of the folder pcaps are stored in
							;should be same as the name of the .rule file in STA
;others
$ChromeWinHandle=""
$SearchTerm=$opt_s
$wait=Number($opt_t)
$DailyMotionTitle=$SearchTerm

;Common Start Routines
;=====================
Call("_CommonStartup")

;Script Actions
;==============
;Run Google Chrome and open dailymotion
Opt("SendKeyDelay",20)
Call("_wb_OpenWithPage","http://www.dailymotion.com/relevance/search/" & $SearchTerm,$DailyMotionTitle)
Opt("SendKeyDelay",5)
WinActivate($_wb_chromeWinHandle)
sleep(500)
$wincoords=WinGetCaretPos()
$wincoords[0]=$wincoords[0]
$coords1=ControlGetPos($_wb_chromeWinHandle,"","[CLASS:Chrome_RenderWidgetHostHWND; INSTANCE:1]")
$finalcoordx=115 + $wincoords[0] + $coords1[0]
$finalcoordy=307 + $wincoords[1] + $coords1[1]
MouseMove($finalcoordx,$finalcoordy,5)
MouseClick("left")
Call("_wb_wait4PageLoad","")
Sleep($wait)

;Close Google Chrome
Call("_wb_ExitChrome")

;Common End Routines
;===================
Call("_CommonEnd")

Exit