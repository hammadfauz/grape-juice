;==Summary======================================
;Download specified torrent
;run Arctic torrent
;open torrent file
;;  Activate open dialog
;;  Select torrent file
;wait for specified time
;remove torrent
;close arctic torrent
;===============================================

#include <file.au3>
#include <Date.au3>
#include <..\DPI_UDF.au3>
#include <AC_bittorrent_UDF.au3>
#include <Math.au3>
#include <array.au3>

;Command Line Parameters
;=======================
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Note: Do NOT specify n,r as option switches,  ;;
;; it is used for testcase name, network scenario ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Default Values
Global $opt_t=60000	;time to capture in millisec
Global $opt_d="EZTV"	;torrent to search for | nobrowser to download pre-fetched torrent
;Reading Command Line arguments for variable initialization
Call("_ReadCmdLineParams",":t:d")

;Local Variable Declarations
;===========================
;Commons but modify for each script
$AppPath="C:\Program Files\Arctic\"		;as you would type in startmenu
$AppProcess="arctic.exe"	;needed for capture filter
$AppRuleName='bittorrent'	;will be the name of the folder pcaps are stored in
							;should be same as the name of the .rule file in STA
;others
$SearchTerm=$opt_d
$ArcticMainTitle="Arctic"
$ArcticOpenTitle="Open"
$ArcticWinHandle=""
$TimeToRun=Number($opt_t)

;Common Start Routines
;=====================
Call("_CommonStartup")

;Script Actions
;==============
;Download specified torrent
$Numtries=0
While $_bt_torrentfile = ""
	Call("_bt_GetTorrent", $SearchTerm)
	$Numtries=$NumTries+1
	If $NumTries=10 Then
		Call("_ErrornQuit","Failed to download torrent file after 10 tries","$_bt_torrentfile")
	EndIf
WEnd
;run Anatomic p2p
Sleep(2000)
$ArcticWinHandle=Call("_LaunchApp",$AppPath & $AppProcess,$ArcticMainTitle)
sleep(2000)
;open torrent file
ControlSend($ArcticWinHandle,"","","{ALTDOWN}f{ALTUP}o")
;;Activate open dialog
Do
	WinActivate($ArcticOpenTitle)
	Sleep(200)
	$Numtries=$Numtries+1
	If $NumTries=30 Then
		Call("_ErrornQuit","Failed to Activate Open File Dialog","WinActivate($ArcticOpenTitle)")
	EndIf
Until WinActive($ArcticOpenTitle)
;;Select torrent file
sleep(2000)
Opt("SendKeyDelay",20)
ControlSend($ArcticOpenTitle,"","[CLASS:Edit; INSTANCE:1]",$_bt_downloaddir & $_bt_torrentfile & "{ENTER}")
if WinActive("Save Torrent File") Then
	ControlSend("SaveTorrent File","","","{ENTER}")
EndIf
;Wait for specified time
Sleep($TimeToRun)
;remove torrent
WinActivate($ArcticWinHandle)
sleep(500)
$wincoords=WinGetCaretPos()
$wincoords[0]=$wincoords[0]
$coords1=ControlGetPos($ArcticWinHandle,"","[CLASS:SysListView32; INSTANCE:1]")
$finalcoordx=54 + $wincoords[0] + $coords1[0]
$finalcoordy=30 + $wincoords[1] + $coords1[1]
MouseMove($finalcoordx,$finalcoordy,5)
MouseClick("right")
Sleep(500)
Send("{UP}{ENTER}")
Sleep(500)
ControlSend("Remove Torrent","","","{ENTER}")
Sleep(7000)
;close anatomic
Call("_CloseWin",$ArcticWinHandle)
ControlSend("Question","","[CLASS:gdkWindowChild; INSTANCE:2]","{ENTER}")
Sleep(1000)

;Common End Routines
;===================
Call("_CommonEnd")

exit