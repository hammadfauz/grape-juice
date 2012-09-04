; Script Version: 1.0
;==Summary======================================
;run emule
;connect to a server with lowest users
;search for a file
;download multiple results
;wait for specified time
;remove downloads
;close emule
;===============================================

#include <file.au3>
#include <Date.au3>
#include <..\DPI_UDF.au3>
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
Global $opt_d = "timbaland" ;search term for download
;Reading Command Line arguments for variable initialization
Call("_ReadCmdLineParams", ":t:d")

;Local Variable Declarations
;===========================
;Commons but modify for each script
$AppPath = "C:\Program Files\eMulePlus\" ;path of app executable
$AppProcess = "emule.exe" ;needed for capture filter
$AppRuleName = 'edonkey' ;will be the name of the folder pcaps are stored in
;should be same as the name of the .rule file in STA
;others
$emuleTitle = "eMule "
$emuleWinHandle = ""
$TimeToRun = $opt_t
$SearchTerm = $opt_d

;Common Start Routines
;=====================
Call("_CommonStartup",1)

;Script Actions
;==============
;Run emule
$emuleWinHandle = Call("_LaunchApp", $AppPath & $AppProcess, $emuleTitle)
Sleep(4000)
;Call("_MaximizeWin",$emuleWinHandle)

;connect to a server with lowest users
Call('_MouseMoveNClick',$emuleWinHandle,"[CLASS:SysHeader32; INSTANCE:1]",170,10,"left")
sleep(100)
Call('_MouseMoveNClick',$emuleWinHandle,"[CLASS:SysHeader32; INSTANCE:1]",170,10,"left")
Call('_MouseMoveNClick',$emuleWinHandle,"[CLASS:SysListView32; INSTANCE:1]",60,30,"left",2)
sleep(1000)
$WaitTimeout=0
$retryCount=0
while StringRegExp(StatusbarGetText($emuleWinHandle,"","7"),"Connecting",0)
	Sleep(1000)
	if $WaitTimeout=30 Then
		$retryCount=$retryCount+1
		Call('_MouseMoveNClick',$emuleWinHandle,"[CLASS:SysListView32; INSTANCE:1]",60,30+(20*$retryCount),"left",2)
		$WaitTimeout=0
		If $retryCount=10 Then
			Call("_ErrornQuit","Failed to connect to any server","StatusbarGetText")
		EndIf
	Else
		$WaitTimeout=$WaitTimeout+1
	EndIf
WEnd
;search for a file
Call('_MouseMoveNClick',$emuleWinHandle,"[CLASS:ToolbarWindow32; INSTANCE:1]",255,25,"left")
Call('_MouseMoveNClick',$emuleWinHandle,"[CLASS:Button; INSTANCE:8]",50,10,"left")
Call('_MouseMoveNClick',$emuleWinHandle,"[CLASS:ComboBox; INSTANCE:2]",50,10,"left")
ControlSend($emuleWinHandle,"","","g{ENTER}")
ControlSend($emuleWinHandle,"","[CLASS:Edit; INSTANCE:1]","{CTRLDOWN}a{CTRLUP}" & $SearchTerm & "{ENTER}")
Sleep(3000)

;download multiple results
Call("_PauseUntilControlChange",$emuleWinHandle,"[CLASS:SysListView32; INSTANCE:3]")
Call("_PauseUntilControlChange",$emuleWinHandle,"[CLASS:SysListView32; INSTANCE:3]")
For $count = 0 To 10
	Call('_MouseMoveNClick',$emuleWinHandle,"[CLASS:SysListView32; INSTANCE:3]",50,36+(20*$count),"",2)
Next

;wait for specified time
Call('_MouseMoveNClick',$emuleWinHandle,"[CLASS:ToolbarWindow32; INSTANCE:1]",185,25,"left")
Sleep($TimeToRun)

;remove downloads
For $count = 0 To 10
	Call('_MouseMoveNClick',$emuleWinHandle,"[CLASS:SysListView32; INSTANCE:5]",80,30,"left")
	Sleep(100)
	Send("{DEL}")
	Sleep(100)
	Send("{y}")
Next

;close emule
;Call("_CloseWin",$soulSeekWinHandle)
ProcessClose($AppProcess)

;Common End Routines
;===================
Call("_CommonEnd")

Exit