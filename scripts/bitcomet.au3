; Script Version: 1.0
;==Summary======================================
;Download specified torrent
;run bitcomet
;open torrent file
;wait for specified time
;remove torrent
;close bitcomet
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
Global $opt_t = 5000 ;time to capture in millisec
Global $opt_d = "EZTV" ;torrent to search for | nobrowser to download pre-fetched torrent
;Reading Command Line arguments for variable initialization
Call("_ReadCmdLineParams", ":t:d")

;Local Variable Declarations
;===========================
;Commons but modify for each script
$AppPath = "C:\Program Files\BitComet\" ;path of app executable
$AppProcess = "BitComet.exe" ;needed for capture filter
$AppRuleName = 'bittorrent' ;will be the name of the folder pcaps are stored in
;should be same as the name of the .rule file in STA
;others
$SearchTerm = $opt_d
$bitcometTitle = "BitComet 1.23 - "
$bitcometOpenDialgTitle = "Open"
$bitcometOpenDialgTitle2 = "Create new BitTorrent task"
$bitcometDelDialgTitle = "Task Delete Confirmation"
$bitcometAnnoyingTitle = "BitComet"
$bitcometWinHandle = ""
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
;Run bitcomet
Sleep(2000)
$bitcometWinHandle = Call("_LaunchApp", $AppPath & $AppProcess, $bitcometTitle)
;remove torrent
Sleep(500)
$bitcometWinHandle=WinGetHandle($bitcometTitle)
WinActivate($bitcometWinHandle)
$wincoords = WinGetCaretPos()
ConsoleWrite($bitcometWinHandle & @CRLF)
$coords1 = ControlGetPos($bitcometWinHandle, "", "[CLASS:SysListView32; INSTANCE:1]")
$finalcoordx = 54 + $wincoords[0] + $coords1[0]
$finalcoordy = 33 + $wincoords[1] + $coords1[1]
MouseMove($finalcoordx, $finalcoordy, 5)
MouseClick("left")
Sleep(3000)
Send("{DEL}")
Sleep(1000)
ControlSend($bitcometDelDialgTitle,"","","{ENTER}")
;open torrent file
$NumTries=0
Do
	ControlSend($bitcometWinHandle,"","","{CTRLDOWN}o{CTRLUP}")
	Sleep(100)
	$NumTries=$NumTries+1
	If $NumTries=30 Then
		Call("_ErrornQuit","No open torrent file dialog","ControlSend")
	EndIf
Until WinExists($bitcometOpenDialgTitle)
Sleep(2000)
ControlSend($bitcometOpenDialgTitle, "", "[CLASS:Edit; INSTANCE:1]", $_bt_downloaddir & $_bt_torrentfile & "{ENTER}")
ControlSend($bitcometAnnoyingTitle, "", "", "{ENTER}")
Sleep(500)
WinActivate($bitcometOpenDialgTitle2)
$wincoords = WinGetCaretPos()
$wincoords[0] = $wincoords[0]
$coords1 = ControlGetPos($bitcometOpenDialgTitle2, "", "[CLASS:Button; INSTANCE:25]")
$finalcoordx = 50 + $wincoords[0] + $coords1[0]
$finalcoordy = 15 + $wincoords[1] + $coords1[1]
MouseMove($finalcoordx, $finalcoordy, 5)
MouseClick("left")
Sleep(500)
ControlSend($bitcometAnnoyingTitle, "", "", "{ENTER}")
Sleep(1000)
ControlSend($bitcometAnnoyingTitle, "", "", "{ENTER}")

WinActivate($bitcometWinHandle)
Sleep(500)
$wincoords = WinGetCaretPos()
$wincoords[0] = $wincoords[0]
$coords1 = ControlGetPos($bitcometWinHandle, "", "[CLASS:SysListView32; INSTANCE:1]")
$NumTries=0
while $coords1 = 0
	$coords1 = ControlGetPos($bitcometWinHandle, "", "[CLASS:SysListView32; INSTANCE:1]")
	$NumTries=$NumTries+1
	If $NumTries=10 Then
		Call("_ErrornQuit","Failed to get coordinates for SysListView321","ControlGetPos")
	EndIf
wend
$finalcoordx = 54 + $wincoords[0] + $coords1[0]
$finalcoordy = 33 + $wincoords[1] + $coords1[1]
MouseMove($finalcoordx, $finalcoordy, 5)
MouseClick("right")
Sleep(3000)
Send("{DOWN}{ENTER}")
Sleep(1000)

;wait for specified time
Sleep($TimeToRun)

;remove torrent
WinActivate($bitcometWinHandle)
Sleep(500)
$wincoords = WinGetCaretPos()
$wincoords[0] = $wincoords[0]
$coords1 = ControlGetPos($bitcometWinHandle, "", "[CLASS:SysListView32; INSTANCE:1]")
while $coords1 = 0
	$coords1 = ControlGetPos($bitcometWinHandle, "", "[CLASS:SysListView32; INSTANCE:1]")
	ConsoleWrite("AGAIN" & @CRLF)
wend
$finalcoordx = 54 + $wincoords[0] + $coords1[0]
$finalcoordy = 33 + $wincoords[1] + $coords1[1]
MouseMove($finalcoordx, $finalcoordy, 5)
MouseClick("left")
Sleep(3000)
Send("{DEL}")
Sleep(1000)
ControlSend($bitcometDelDialgTitle,"","","{ENTER}")

;Close bitcomet
ProcessClose($AppProcess)

;Common End Routines
;===================
Call("_CommonEnd")

Exit