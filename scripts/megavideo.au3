;==Summary======================================
;Run Google Chrome and open megavideo
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
$MegavideoTitle="MEGAVIDEO"
$SearchTerm=StringRegExpReplace($vid," ","{+}")

;Common Start Routines
;=====================
Call("_CommonStartup")

;Script Actions
;==============
;Run Google Chrome and open megavideo
Opt("SendKeyDelay",20)
Call("_wb_OpenWithPage","http://www.megavideo.com/?c=videos&s=" & $SearchTerm,$MegavideoTitle)
Opt("SendKeyDelay",5)
sleep(1000)
Call("_wb_SelectLink","videos matched")
Sleep(2000)
ControlSend($_wb_chromeWinHandle,"","","{TAB 7}{ENTER}")
Sleep(2000)
Call("_wb_wait4PageLoad","")
WinActivate($_wb_chromeWinHandle)
$wincoords=WinGetCaretPos()
$wincoords[0]=$wincoords[0]
$coords1=ControlGetPos($_wb_chromeWinHandle,"","[CLASS:Chrome_RenderWidgetHostHWND; INSTANCE:1]")
$finalcoordx=540 + $wincoords[0] + $coords1[0]
$finalcoordy=360 + $wincoords[1] + $coords1[1]
MouseMove($finalcoordx,$finalcoordy,5)
MouseClick("left")
Sleep(5000)
;if Not WinActive($MegavideoTitle) Then
;	ControlSend($_wb_chromeWinHandle,"","","{CTRLDOWN}w{CTRLUP}")
;EndIf
sleep(3000)
Call("_wb_wait4PageLoad","")
$wincoords=WinGetCaretPos()
$wincoords[0]=$wincoords[0]
$coords1=ControlGetPos($_wb_chromeWinHandle,"","[CLASS:Chrome_RenderWidgetHostHWND; INSTANCE:1]")
$finalcoordx=540 + $wincoords[0] + $coords1[0]
$finalcoordy=360 + $wincoords[1] + $coords1[1]
MouseMove($finalcoordx,$finalcoordy,5)
MouseClick("left")
MouseClick("left") ;this is why i hate autoit: for some odd reason once doesn't do the trick
Call("_wb_wait4PageLoad","")
Sleep($wait)

;Close Google Chrome
;Call("_wb_ExitChrome")
ProcessClose("chrome.exe")
;Common End Routines
;===================
Call("_CommonEnd")

Exit