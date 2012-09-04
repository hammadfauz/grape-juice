;==Summary======================================
;Run Google Chrome and open atom
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
Global $opt_t = 30000			;time to capture in millisec
;Reading Command Line arguments for variable initialization
Call("_ReadCmdLineParams", ":t")

;Local Variable Declarations
;===========================
;Commons but modify for each script
$AppProcess="chrome.exe"	;needed for capture filter
$AppRuleName='flash'		;will be the name of the folder pcaps are stored in
							;should be same as the name of the .rule file in STA
;others
$ChromeWinHandle=""
$wait=Number($opt_t)
$AtomTitle="Funny Videos"

;Common Start Routines
;=====================
Call("_CommonStartup")

;Script Actions
;==============
;Run Google Chrome and open ncaa
Opt("SendKeyDelay",20)
Call("_wb_OpenWithPage","http://www.atom.com/funny_videos/?proFilter=d1cc629c-ac4f-497e-9dfa-1e5be730a8ed",$AtomTitle)
Opt("SendKeyDelay",5)
Sleep(5000)
Call("_wb_selectLink","date")
ControlSend($_wb_chromeWinHandle,"","","{TAB}{ENTER}")
Call("_wb_wait4PageLoad","")
Sleep($wait)

;Close Google Chrome
Call("_wb_ExitChrome")

;Common End Routines
;===================
Call("_CommonEnd")

Exit