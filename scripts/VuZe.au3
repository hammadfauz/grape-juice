; Script Version: 1.0
;==Summary======================================
;Download specified torrent
;run vuze
;open torrent file
;wait for specified time
;remove torrent
;close vuze
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
$AppPath = "C:\Program Files\Azureus\" ;path of app executable
$AppProcess = "Azureus.exe" ;needed for capture filter
$AppRuleName = 'bittorrent' ;will be the name of the folder pcaps are stored in
;should be same as the name of the .rule file in STA
;others
$SearchTerm = $opt_d
$VuzeTitle = "Azureus"
$VuzeOpenDialgTitle = "Open Torrent(s)"
$VuzeOpenDialgTitle2 = "Choose the torrent file"
$VuzeDeleteDialgTitle = "Delete Content"
$FileExistsDialgTitle = "File(s) already exist!"
$VuzeWinHandle = ""
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
;Run Vuze
Sleep(2000)
$VuzeWinHandle = Call("_LaunchApp", $AppPath & $AppProcess, $VuzeTitle)
Sleep(2000)
WinActivate($vuzeWinHandle)
Sleep(2000)
;remove torrent
WinActivate($vuzeWinHandle)
sleep(2000)
$wincoords=WinGetCaretPos()
$wincoords[0]=$wincoords[0]
$coords1=ControlGetPos($VuzeTitle,"","[CLASS:SWT_Window0; INSTANCE:23]")
;ConsoleWrite($coords1 & @CRLF)
$finalcoordx=0 + $wincoords[0] + $coords1[0]
$finalcoordy=15 + $wincoords[1] + $coords1[1]
MouseMove($finalcoordx,$finalcoordy,5)
Sleep(3000)
MouseClick("left")
Sleep(500)
WinActivate($VuzeTitle)
Sleep(500)
$wincoords = WinGetCaretPos()
$wincoords[0] = $wincoords[0]
$coords1 = ControlGetPos($VuzeTitle, "", "[CLASS:SysListView32; INSTANCE:1]")
$finalcoordx = 54 + $wincoords[0] + $coords1[0]
$finalcoordy = 30 + $wincoords[1] + $coords1[1]
MouseMove($finalcoordx, $finalcoordy, 5)
MouseClick("left")
Sleep(1000)
Send("{DEL}")
Sleep(500)
if WinExists($VuzeDeleteDialgTitle) Then
	ControlSend($VuzeDeleteDialgTitle,"","[CLASS:Button; INSTANCE:5]","{ENTER}")
	Sleep(1000)
EndIf
;open torrent file
Do
	;Send("{CTRLDOWN}o{CTRLUP}")
	ControlSend($VuzeTitle,"","","{CTRLDOWN}o{CTRLUP}")
	Sleep(100)
Until WinExists($VuzeOpenDialgTitle)
Sleep(1000)
Do
	WinActivate($VuzeOpenDialgTitle)
	$wincoords = WinGetPos($VuzeOpenDialgTitle)
	$wincoords[0] = $wincoords[0]
	$coords1 = ControlGetPos($VuzeOpenDialgTitle, "", "[CLASS:Button; INSTANCE:1]")
	$finalcoordx = 30 + $wincoords[0] + $coords1[0]
	$finalcoordy = 30 + $wincoords[1] + $coords1[1]
	MouseMove($finalcoordx, $finalcoordy, 5)
	MouseClick("left")
	Sleep(2000)
Until WinExists($VuzeOpenDialgTitle2)
Sleep(2000)
ControlSend($VuzeOpenDialgTitle2, "", "[CLASS:Edit; INSTANCE:1]", $_bt_downloaddir & $_bt_torrentfile & "{ENTER}")
Sleep(500)
WinActivate($VuzeOpenDialgTitle)
$wincoords = WinGetPos($VuzeOpenDialgTitle)
$wincoords[0] = $wincoords[0]
$coords1 = ControlGetPos($VuzeOpenDialgTitle, "", "[CLASS:Button; INSTANCE:11]")
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
WinActivate($VuzeTitle)
Sleep(500)
$wincoords = WinGetCaretPos()
$wincoords[0] = $wincoords[0]
$coords1 = ControlGetPos($VuzeTitle, "", "[CLASS:SysListView32; INSTANCE:1]")
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