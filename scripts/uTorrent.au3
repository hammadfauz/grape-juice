; Script Version: 1.2
;==Summary======================================
;Download specified torrent
;run uTorrent
;open torrent file
;wait for specified time
;remove torrent
;close uTorrent
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
Global $opt_t = 60000 ;time to capture in millisec
Global $opt_d = "nobrowser" ;torrent to search for | nobrowser to download pre-fetched torrent
;Reading Command Line arguments for variable initialization
Call("_ReadCmdLineParams", ":t:d")

;Local Variable Declarations
;===========================
;Commons but modify for each script
$AppPath = "C:\Program Files\uTorrent\" ;path of app executable
$AppProcess = "uTorrent.exe" ;needed for capture filter
$AppRuleName = 'bittorrent' ;will be the name of the folder pcaps are stored in
;should be same as the name of the .rule file in STA
;others
$SearchTerm = $opt_d
$uTorrentTitle = "µTorrent"
$uTorrentOpenDialgTitle = "Select a .torrent to open"
$uTorrentOpenDialgTitle2 = " - Add New Torrent"
$uTorrentWinHandle = ""
$TimeToRun = Number($opt_t)

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
;Run uTorrent
Sleep(2000)
$uTorrentWinHandle = Call("_LaunchApp", $AppPath & $AppProcess, $uTorrentTitle)
Sleep(2000)
WinActivate($uTorrentWinHandle)
Sleep(2000)
;remove torrent
WinActivate($uTorrentWinHandle)
Sleep(500)
$wincoords = WinGetCaretPos()
$wincoords[0] = $wincoords[0]
$coords1 = ControlGetPos($uTorrentWinHandle, "", "[CLASS:SysListView32; INSTANCE:2]")
$finalcoordx = 54 + $wincoords[0] + $coords1[0]
$finalcoordy = 33 + $wincoords[1] + $coords1[1]
MouseMove($finalcoordx, $finalcoordy, 5)
MouseClick("right")
Sleep(3000)
Send("r")
Sleep(1000)
;open torrent file
Do
	Send("{CTRLDOWN}o{CTRLUP}")
	;ControlSend($uTorrentWinHandle,"","","{CTRLDOWN}o{CTRLUP}")
	Sleep(100)
Until WinExists($uTorrentOpenDialgTitle)
Sleep(2000)
Opt("SendKeyDelay",20)
ControlSend($uTorrentOpenDialgTitle, "", "[CLASS:Edit; INSTANCE:1]", $_bt_downloaddir & $_bt_torrentfile & "{ENTER}")
Opt("WinTitleMatchMode", 2)
Sleep(2000)
ControlSend($uTorrentOpenDialgTitle2, "", "", "{ENTER}")
Opt("WinTitleMatchMode", 1)
Sleep(2000)
Send("{ENTER}")

;wait for specified time
Sleep($TimeToRun)

;remove torrent
WinActivate($uTorrentWinHandle)
Sleep(500)
$wincoords = WinGetCaretPos()
$wincoords[0] = $wincoords[0]
$coords1 = ControlGetPos($uTorrentWinHandle, "", "[CLASS:SysListView32; INSTANCE:2]")
$finalcoordx = 54 + $wincoords[0] + $coords1[0]
$finalcoordy = 33 + $wincoords[1] + $coords1[1]
MouseMove($finalcoordx, $finalcoordy, 5)
MouseClick("right")
Sleep(3000)
Send("r")
Sleep(1000)

;Close uTorrent
;Call("_CloseWin",$uTorrentWinHandle)
ProcessClose("uTorrent.exe")

;Common End Routines
;===================
Call("_CommonEnd")

Exit