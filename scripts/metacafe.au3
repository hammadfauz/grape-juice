;==Summary======================================
;Run Google Chrome and open metacafe
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
$vid=$opt_s
$wait=Number($opt_t)
$MetaCafeTitle=$vid
$SearchTerm=StringRegExpReplace($vid," ","_")

;Common Start Routines
;=====================
Call("_CommonStartup")

;Script Actions
;==============
;Run Google Chrome and open metacafe
Opt("WinTitleMatchMode",-1)
Opt("SendKeyDelay",20)
Call("_wb_OpenWithPage","http://www.metacafe.com/videos_about/" & $SearchTerm,$MetaCafeTitle)
Opt("SendKeyDelay",5)
Opt("WinTitleMatchMode",1)
sleep(500)
Call("_wb_SelectLink","newest")
Sleep(2000)
ControlSend($_wb_chromeWinHandle,"","","{TAB 3}{ENTER}")
Call("_wb_wait4PageLoad","")
Sleep($wait)

;Close Google Chrome
Call("_wb_ExitChrome")

;Common End Routines
;===================
Call("_CommonEnd")

Exit