;==Summary======================================
;Download specified torrent
;run Anatomic-p2p
;open torrent file
;;  Activate open dialog
;;  Select torrent file
;wait for specified time
;close anatomic
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
Global $opt_d="nobrowser"	;torrent to search for | nobrowser to download pre-fetched torrent
;Reading Command Line arguments for variable initialization
Call("_ReadCmdLineParams",":t:d")

;Local Variable Declarations
;===========================
;Commons but modify for each script
$AppPath="C:\Program Files\Anatomic P2P\"		;as you would type in startmenu
$AppProcess="anatomicgui.exe"	;needed for capture filter
$AppRuleName='bittorrent'	;will be the name of the folder pcaps are stored in
							;should be same as the name of the .rule file in STA
;others
$SearchTerm=$opt_d
$AnatomicMainTitle="Anatomic P2P"
$AnatomicOpenTitle="Browse For Torrent"
$AnatomicWinHandle=""
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
$AnatomicWinHandle=Call("_LaunchApp",$AppPath & $AppProcess,$AnatomicMainTitle,"C:\Program Files\Anatomic P2P")
Sleep(1000)
;open torrent file
;;Activate open dialog
$NumTries=0
Do
	WinActivate($AnatomicOpenTitle)
	Sleep(200)
	$Numtries=$Numtries+1
	If $NumTries=30 Then
		Call("_ErrornQuit","Failed to Activate Open File Dialog","WinActivate($AnatomicOpenTitle)")
	EndIf
Until WinActive($AnatomicOpenTitle)
;;Select torrent file
ControlSend($AnatomicOpenTitle,"","","{TAB 4}")
sleep(200)
ControlSend($AnatomicOpenTitle,"","","{DOWN 20}{ENTER}")
sleep(200)
ControlSend($AnatomicOpenTitle,"","","{DOWN 50}{ENTER}")
Sleep(2000)
$Numtries=0
while WinActive("Save Torrent File")
	ControlSend("Save Torrent File","","","{ENTER}")
	Sleep(1000)
	$Numtries=$NumTries+1
	If $NumTries=10 Then
		Call("_ErrornQuit","Failed to interact with Save Torrent Flie dialog","WinActive(Save Torrent File)")
	EndIf
WEnd
Sleep(1000)
Call("_MouseMoveNClick","Choose folder to save to","[CLASS:gdkWindowChild; INSTANCE:4]",55,15,"left",1)
;Wait for specified time
Sleep($TimeToRun)
;close anatomic
Call("_CloseWin",$AnatomicWinHandle)
ControlSend("Question","","[CLASS:gdkWindowChild; INSTANCE:2]","{ENTER}")
Sleep(1000)
ProcessClose($AppProcess)
;Common End Routines
;===================
Call("_CommonEnd")

exit