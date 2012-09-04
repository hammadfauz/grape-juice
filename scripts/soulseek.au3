; Script Version: 1.0
;==Summary======================================
;run SoulSeek
;search for specified file
;put multiple results for download
;wait for specified time
;remove downloads
;close SoulSeek
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
$AppPath = "C:\Program Files\SoulseekNS\" ;path of app executable
$AppProcess = "slsk.exe" ;needed for capture filter
$AppRuleName = 'soulseek' ;will be the name of the folder pcaps are stored in
;should be same as the name of the .rule file in STA
;others
$SearchTerm = $opt_d
$SoulSeekTitle = "SoulSeek "
$SoulSeekWinHandle = ""
$TimeToRun = Number($opt_t)


;Common Start Routines
;=====================
Call("_CommonStartup")

;Script Actions
;==============
;Run SoulSeek
$SoulSeekWinHandle = Call("_LaunchApp", $AppPath & $AppProcess, $SoulSeekTitle)
Sleep(10000)
;search for specified file
Call('_MouseMoveNClick',$SoulSeekWinHandle,"[CLASS:SysTabControl32; INSTANCE:2]",30,10,"left")
ControlSend($SoulSeekWinHandle,"","[CLASS:Edit; INSTANCE:1]",$SearchTerm & "{ENTER}")
Sleep(3000)
;put multiple results for download
For $count = 0 To 5
	Call('_MouseMoveNClick',$SoulSeekWinHandle,"[CLASS:SysListView32; INSTANCE:1]",50,30+(20*$count),"",2)
Next
;wait for specified time
Sleep($TimeToRun)
;remove downloads
Call('_MouseMoveNClick',$SoulSeekWinHandle,"[CLASS:SysTabControl32; INSTANCE:1]",100,10)
for $count = 1 To 6
	Call('_MouseMoveNClick',$SoulSeekWinHandle,"[CLASS:SysListView32; INSTANCE:1]",30,30,"right")
	Send("d")
Next
;Close SoulSeek
;Call("_CloseWin",$soulSeekWinHandle)
ProcessClose($AppProcess)

;Common End Routines
;===================
Call("_CommonEnd")

Exit