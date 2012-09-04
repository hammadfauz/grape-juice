; Script Version: 1.2
;==Summary======================================
;Download specified torrent
;run BitTorrent
;open torrent file
;wait for specified time
;remove torrent
;close BitTorrent
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
Global $opt_t = 15000 ;time to capture in millisec
Global $opt_d = "EZTV" ;torrent to search for | nobrowser to download pre-fetched torrent
;Reading Command Line arguments for variable initialization
Call("_ReadCmdLineParams", ":t:d")

;Local Variable Declarations
;===========================
;Commons but modify for each script
$AppPath = "C:\Program Files\BitTorrent\" ;path of app executable
$AppProcess = "BitTorrent.exe" ;needed for capture filter
$AppRuleName = 'bittorrent' ;will be the name of the folder pcaps are stored in
;should be same as the name of the .rule file in STA
;others
$SearchTerm = $opt_d
$BitTorrentTitle = "BitTorrent "
$BitTorrentOpenDialgTitle = "Select a torrent to open"
$BitTorrentOpenDialgTitle2 = " - Add New Torrent"
$BitTorrentWinHandle = ""
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
$BitTorrentWinHandle = Call("_LaunchApp", $AppPath & $AppProcess, $BitTorrentTitle)
ConsoleWrite($AppPath & $AppProcess)
Sleep(2000)
WinActivate($BitTorrentWinHandle)
Sleep(2000)
;remove torrent
WinActivate($BitTorrentWinHandle)
Sleep(500)
$wincoords = WinGetCaretPos()
$wincoords[0] = $wincoords[0]
$coords1 = ControlGetPos($BitTorrentWinHandle, "", "[CLASS:SysListView32; INSTANCE:1]")
$finalcoordx = 54 + $wincoords[0] + $coords1[0]
$finalcoordy = 33 + $wincoords[1] + $coords1[1]
MouseMove($finalcoordx, $finalcoordy, 5)
MouseClick("right")
Sleep(3000)
Send("r")
Sleep(1000)
;open torrent file
$NumTries=0
Do
	Send("{CTRLDOWN}o{CTRLUP}")
	Sleep(100)
	$NumTries=$NumTries+1
	If $NumTries=40 Then
		Call("_ErrornQuit","Failed to get open torrent file dialog","WinExists")
	EndIf
Until WinExists($BitTorrentOpenDialgTitle)
Sleep(2000)
ControlSend($BitTorrentOpenDialgTitle, "", "[CLASS:Edit; INSTANCE:1]", $_bt_downloaddir & $_bt_torrentfile & "{ENTER}")
Opt("WinTitleMatchMode", 2)
Sleep(2000)
ControlSend($BitTorrentOpenDialgTitle2, "", "", "{ENTER}")
Opt("WinTitleMatchMode", 1)

;wait for specified time
Sleep($TimeToRun)

;remove torrent
WinActivate($BitTorrentWinHandle)
Sleep(500)
$wincoords = WinGetCaretPos()
$wincoords[0] = $wincoords[0]
$coords1 = ControlGetPos($BitTorrentWinHandle, "", "[CLASS:SysListView32; INSTANCE:1]")
$finalcoordx = 54 + $wincoords[0] + $coords1[0]
$finalcoordy = 33 + $wincoords[1] + $coords1[1]
MouseMove($finalcoordx, $finalcoordy, 5)
MouseClick("right")
Sleep(3000)
Send("r")
Sleep(1000)

;Close uTorrent
;Call("_CloseWin",$BitTorrentWinHandle)
ProcessClose($AppProcess)

;Common End Routines
;===================
Call("_CommonEnd")

Exit