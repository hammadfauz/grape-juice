;==Summary======================================
;Run Google Chrome and open Youtube
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
$AppRuleName='youtube'		;will be the name of the folder pcaps are stored in
							;should be same as the name of the .rule file in STA
;others
$ChromeWinHandle=""
$vid=$opt_s & "%2C playlist"
$wait=Number($opt_t)
$YouTubeTitle=" - YouTube - Google Chrome"
$SearchTerm=StringRegExpReplace($vid," ","{+}")

;Common Start Routines
;=====================
Call("_CommonStartup")

;Script Actions
;==============
;Run Google Chrome and open youtube
Opt("WinTitleMatchMode",2)
Opt("SendKeyDelay",20)
Call("_wb_OpenWithPage","http://www.youtube.com/results?search_query=" & $SearchTerm,$YouTubeTitle)
Opt("SendKeyDelay",5)
Opt("WinTitleMatchMode",1)
if Call("_wb_SelectLink","Did you mean:") Then
	$tabtwice="yes"
Else
	$tabtwice="no"
EndIf
sleep(500)
Call("_wb_SelectLink","filter")
Sleep(2000)
if $tabtwice="yes" Then
	ControlSend($_wb_chromeWinHandle,"","","{TAB 2}{ENTER}")
Else
	ControlSend($_wb_chromeWinHandle,"","","{TAB}{ENTER}")
EndIf
Sleep($wait)

;Close Google Chrome
Call("_wb_ExitChrome")

;Common End Routines
;===================
Call("_CommonEnd")

Exit