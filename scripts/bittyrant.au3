; Script Version: 1.0
;==Summary======================================
;Download specified torrent
;run BitTyrant
;open torrent file
;wait for specified time
;remove torrent
;close BitTyrant
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
$AppPath = "C:\Program Files\BitTyrant\" ;path of app executable
$AppProcess = "Azureus.exe" ;needed for capture filter
$AppRuleName = 'bittorrent' ;will be the name of the folder pcaps are stored in
;should be same as the name of the .rule file in STA
;others
$SearchTerm = $opt_d
$BitTyrantTitle = "Azureus BitTyrant"
$BitTyrantOpenDialgTitle = "Open Torrent(s)"
$BitTyrantOpenDialgTitle2 = "Choose the torrent file"
$BitTyrantDeleteDialgTitle = "Delete Content"
$bitTyrantAnnoyingTitle = "Azureus Updater"
$FileExistsDialgTitle = "File(s) already exist!"
$BitTyrantWinHandle = ""
$TimeToRun = Number($opt_t)

;Common Start Routines
;=====================
Call("_CommonStartup",1)

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
;Run Vuze
Sleep(2000)
$BitTyrantWinHandle = Call("_LaunchApp", $AppPath & $AppProcess, $BitTyrantTitle)
$timeout=0
Do
	Sleep(1000)
	$timeout=$timeout+1
Until WinExists($bitTyrantAnnoyingTitle) Or $timeout=15
ControlSend($bitTyrantAnnoyingTitle,"","","{ESC}")
WinActivate($BitTyrantWinHandle)
Sleep(2000)
;remove torrent
WinActivate($BitTyrantWinHandle)
Sleep(500)
$wincoords = WinGetCaretPos()
$wincoords[0] = $wincoords[0]
$coords1 = ControlGetPos($BitTyrantWinHandle, "", "[CLASS:SysListView32; INSTANCE:1]")
$finalcoordx = 54 + $wincoords[0] + $coords1[0]
$finalcoordy = 30 + $wincoords[1] + $coords1[1]
MouseMove($finalcoordx, $finalcoordy, 5)
MouseClick("left")
Sleep(1000)
Send("{DEL}")
Sleep(500)
;open torrent file
Do
	ControlSend($BitTyrantWinHandle,"","","{CTRLDOWN}o{CTRLUP}")
	Sleep(100)
Until WinExists($BitTyrantOpenDialgTitle)
Do
	WinActivate($BitTyrantOpenDialgTitle)
	$wincoords = WinGetPos($BitTyrantOpenDialgTitle)
	$wincoords[0] = $wincoords[0]
	$coords1 = ControlGetPos($BitTyrantOpenDialgTitle, "", "[CLASS:Button; INSTANCE:1]")
	$finalcoordx = 30 + $wincoords[0] + $coords1[0]
	$finalcoordy = 30 + $wincoords[1] + $coords1[1]
	MouseMove($finalcoordx, $finalcoordy, 5)
	MouseClick("left")
	Sleep(2000)
Until WinExists($BitTyrantOpenDialgTitle2)
Sleep(2000)
Opt("SendKeyDelay",20)
ControlSend($BitTyrantOpenDialgTitle2, "", "[CLASS:Edit; INSTANCE:1]", $_bt_downloaddir & $_bt_torrentfile & "{ENTER}")
Sleep(500)
WinActivate($BitTyrantOpenDialgTitle)
$wincoords = WinGetPos($BitTyrantOpenDialgTitle)
$wincoords[0] = $wincoords[0]
$coords1 = ControlGetPos($BitTyrantOpenDialgTitle, "", "[CLASS:Button; INSTANCE:11]")
$finalcoordx = 30 + $wincoords[0] + $coords1[0]
$finalcoordy = 30 + $wincoords[1] + $coords1[1]
MouseMove($finalcoordx, $finalcoordy, 5)
MouseClick("left")
if WinExists($FileExistsDialgTitle) Then
	send("{ENTER}")
EndIf
;wait for specified time
Sleep($TimeToRun)
;remove torrent
WinActivate($BitTyrantWinHandle)
Sleep(500)
$wincoords = WinGetCaretPos()
$wincoords[0] = $wincoords[0]
$coords1 = ControlGetPos($BitTyrantWinHandle, "", "[CLASS:SysListView32; INSTANCE:1]")
$finalcoordx = 54 + $wincoords[0] + $coords1[0]
$finalcoordy = 30 + $wincoords[1] + $coords1[1]
MouseMove($finalcoordx, $finalcoordy, 5)
MouseClick("left")
Sleep(1000)
Send("{DEL}")
Sleep(500)
;Close Vuze
ProcessClose($AppProcess)

;Common End Routines
;===================
Call("_CommonEnd")

Exit