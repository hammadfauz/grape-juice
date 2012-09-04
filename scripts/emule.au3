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
$AppPath = "C:\Program Files\eMule\" ;path of app executable
$AppProcess = "emule.exe" ;needed for capture filter
$AppRuleName = 'edonkey' ;will be the name of the folder pcaps are stored in
;should be same as the name of the .rule file in STA
;others
$emuleTitle = "eMule "
$emuleWinHandle = ""
$TimeToRun = Number($opt_t)
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
While WinExists("Updating server list")
	sleep(1000)
WEnd
Call('_MouseMoveNClick',$emuleWinHandle,"[CLASS:SysHeader32; INSTANCE:1]",170,10,"left")
sleep(100)
Call('_MouseMoveNClick',$emuleWinHandle,"[CLASS:SysHeader32; INSTANCE:1]",170,10,"left")
Call('_MouseMoveNClick',$emuleWinHandle,"[CLASS:SysListView32; INSTANCE:1]",60,30,"left",2)
sleep(3000)
$WaitTimeout=0
$retryCount=0
While StringRegExp(StatusbarGetText($emuleWinHandle,"","5"),"Preparing...",0)
	Sleep(1000)
WEnd
while Not StringRegExp(StatusbarGetText($emuleWinHandle,"","4"),"eD2K:Connected*",0)
	Sleep(1000)
	if $WaitTimeout=30 Then
		$retryCount=$retryCount+1
		Call('_MouseMoveNClick',$emuleWinHandle,"[CLASS:SysListView32; INSTANCE:1]",60,30+(20*$retryCount),"left",2)
		$WaitTimeout=0
	Else
		$WaitTimeout=$WaitTimeout+1
	EndIf
	If $RetryCount=10 Then
		Call("_ErrornQuit","Could not connect to any server","StatusBarGetText")
	EndIf
WEnd

;search for a file
Call('_MouseMoveNClick',$emuleWinHandle,"[CLASS:ToolbarWindow32; INSTANCE:1]",330,25,"left")
Call('_MouseMoveNClick',$emuleWinHandle,"[CLASS:Button; INSTANCE:14]",50,10,"left")
ControlSend($emuleWinHandle,"","[CLASS:Edit; INSTANCE:7]","{CTRLDOWN}a{CTRLUP}" & $SearchTerm & "{ENTER}")
Sleep(3000)

;download multiple results
Call("_PauseUntilControlChange",$emuleWinHandle,"[CLASS:SysListView32; INSTANCE:3]")
For $count = 0 To 10
	Call('_MouseMoveNClick',$emuleWinHandle,"[CLASS:SysListView32; INSTANCE:3]",50,36+(20*$count),"",2)
Next

;wait for specified time
Call('_MouseMoveNClick',$emuleWinHandle,"[CLASS:ToolbarWindow32; INSTANCE:1]",260,25,"left")
Sleep($TimeToRun)

;remove downloads
Call('_MouseMoveNClick',$emuleWinHandle,"[CLASS:SysListView32; INSTANCE:6]",35,30,"left")
For $count = 0 To 10
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