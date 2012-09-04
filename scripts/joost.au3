;==Summary======================================
;Run Google Chrome and open joost
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
Global $opt_s = "science experiment"	;video to search for
Global $opt_t = 30000			;time to capture in millisec
;Reading Command Line arguments for variable initialization
Call("_ReadCmdLineParams", ":s:t")

;Local Variable Declarations
;===========================
;Commons but modify for each script
$AppProcess="chrome.exe"	;needed for capture filter
$AppRuleName='joost'		;will be the name of the folder pcaps are stored in
							;should be same as the name of the .rule file in STA
;others
$SearchTerm=$opt_s
$wait=Number($opt_t)
$JoostTitle="Joost"
$SearchResultTitle="Search videos for"

;Common Start Routines
;=====================
Call("_CommonStartup")

;Script Actions
;==============
;Run Google Chrome and open vimeo
Opt("SendKeyDelay",20)
Call("_wb_OpenWithPage","http://www.joost.com",$JoostTitle)
Opt("SendKeyDelay",5)
Sleep(5000)
Call("_MouseMoveNClick",$_wb_ChromeWinHandle,"[CLASS:Chrome_RenderWidgetHostHWND; INSTANCE:1]",190,125)
Sleep($wait)

;Close Google Chrome
Call("_wb_ExitChrome")

;Common End Routines
;===================
Call("_CommonEnd")

Exit