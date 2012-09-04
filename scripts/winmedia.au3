;==Summary======================================
;Run stream files with windows media player
;wait for specified time
;Close Windows media player
;===============================================

#Include <Clipboard.au3>
#include <file.au3>
#include <..\DPI_UDF.au3>
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
$AppPath = "C:\Program Files\Windows Media Player\" ;path of app executable
$AppProcess="wmplayer.exe"	;needed for capture filter
$AppRuleName='win-media'		;will be the name of the folder pcaps are stored in
							;should be same as the name of the .rule file in STA
;others
$WMPlayerTitle="Windows Media Player"
$WMPlayerWinHandle=""
Opt("SendKeyDelay",10)
$FileToPlay="C:\users\Administrator\Desktop\radio.wax"
$wait=Number($opt_t)

;Common Start Routines
;=====================
Call("_CommonStartup",1)

;Script Actions
;==============
;Run stream files with windows media player
$WMPlayerWinHandle = Call("_LaunchApp", $AppPath & $AppProcess, $WMPlayerTitle)
sleep(500)
WinActivate($WMPlayerWinHandle)
Do
	ControlSend($WMPlayerWinHandle,"","","{CTRLDOWN}o{CTRLUP}")
	Sleep(100)
Until WinExists("Open")
ControlSend("Open", "", "[CLASS:Edit; INSTANCE:1]",$FileToPlay & "{ENTER}")
;wait for specified time
Sleep($wait)
;Close Windows Media Player
;while WinExists($WMPlayerWinHandle)
	ProcessClose($AppProcess)
	Sleep(100)
;WEnd
;Common End Routines
;===================
Call("_CommonEnd")

Exit