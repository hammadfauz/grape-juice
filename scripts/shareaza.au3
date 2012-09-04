; Script Version: 1.0
;==Summary======================================
;run shareaza
;search for a file
;wait for results to appear
;download multiple results
;wait for specified time
;remove downloads
;close shareaza
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
Global $opt_t = 60000 ;time to capture in milliseconds
Global $opt_d = "timbaland" ;search term
;Reading Command Line arguments for variable initialization
Call("_ReadCmdLineParams", ":t:d")

;Local Variable Declarations
;===========================
;Commons but modify for each script
$AppPath = "C:\Program Files\Shareaza\" ;path of app executable
$AppProcess = "Shareaza.exe" ;needed for capture filter
$AppRuleName = 'gnutella' ;will be the name of the folder pcaps are stored in
;should be same as the name of the .rule file in STA
;others
$ShareazaTitle = "[CLASS:ShareazaMainWnd]"
$ShareazaWinHandle = ""
$TimeToRun = Number($opt_t)
$SearchTerm = $opt_d

;Common Start Routines
;=====================
Call("_CommonStartup",1)

;Script Actions
;==============
;Run emule
$ShareazaWinHandle = Call("_LaunchApp", $AppPath & $AppProcess, $ShareazaTitle)
Sleep(1000)
;Call("_MaximizeWin",$ShareazaWinHandle)

;search for a file
Call('_MouseMoveNClick',$ShareazaWinHandle,"[CLASS:AfxControlBar90su; INSTANCE:1]",360-2,20+26,"left")
ControlSend($ShareazaWinHandle,"","[CLASS:Edit; INSTANCE:2]","{CTRLDOWN}a{CTRLUP}" & $SearchTerm & "{ENTER}")
sleep(1000)

;wait for results to appear
For $count = 0 To 4
	$positions=ControlGetPos($ShareazaWinHandle,"","[CLASS:AfxWnd90su; INSTANCE:1]")
	$HasNotChanged=PixelChecksum($positions[0],$positions[1],$positions[0]+$positions[2],$positions[1]+$positions[3])
	$NumTries=0
	While PixelChecksum($positions[0],$positions[1],$positions[0]+$positions[2],$positions[1]+$positions[3])=$HasNotChanged
		Sleep(1000)
		$NumTries=$NumTries+1
		If $NumTries=60 Then
			Call("_ErrornQuit","No search results seen","PixelChecksum")
		EndIf
	WEnd
Next
;Sleep(30000)

;download multiple results
For $count = 0 To 10
	Call('_MouseMoveNClick',$ShareazaWinHandle,"[CLASS:AfxControlBar90su; INSTANCE:1]",50-2,20+62,"left")
	sleep(100)
	Call('_MouseMoveNClick',$ShareazaWinHandle,"[CLASS:AfxWnd90su; INSTANCE:1]",50,36+(20*$count),"",2)
	sleep(100)
	If WinExists("Existing File") Then
		Call('_MouseMoveNClick',"Existing File","[CLASS:Button; INSTANCE:5]]",25,15,"left")
	EndIf
Next
Call('_MouseMoveNClick',$ShareazaWinHandle,"[CLASS:AfxControlBar90su; INSTANCE:1]",190-2,10+62,"left")
sleep(100)
Call('_MouseMoveNClick',$ShareazaWinHandle,"[CLASS:AfxControlBar90su; INSTANCE:1]",190-2,10+62,"left")

;wait for specified time
Call('_MouseMoveNClick',$ShareazaWinHandle,"[CLASS:AfxControlBar90su; INSTANCE:1]",460-2,20+26,"left")
sleep(100)
Call('_MouseMoveNClick',$ShareazaWinHandle,"[CLASS:AfxControlBar90su; INSTANCE:1]",460-2,20+26,"left")
Sleep($TimeToRun)

;remove downloads
For $count = 0 To 10
	Call('_MouseMoveNClick',$ShareazaWinHandle,"[CLASS:AfxWnd90su; INSTANCE:3]",40,30,"left")
	Sleep(100)
	Send("{DEL}")
	If WinExists("Delete File") Then
		Call('_MouseMoveNClick',"Delete File","[CLASS:Button; INSTANCE:1]",25,15,"left")
	EndIf
Next

;close shareaza
sleep(100)
ProcessClose($AppProcess)

;Common End Routines
;===================
Call("_CommonEnd")

Exit