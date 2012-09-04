; Script Version: 1.0
;==Summary======================================
;run ApexDC++
;download random file lists
;wait for specified time
;close ApexDC++
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
Global $opt_t = 60000 ;time to capture in millisec
;Reading Command Line arguments for variable initialization
Call("_ReadCmdLineParams", ":t")

;Local Variable Declarations
;===========================
;Commons but modify for each script
$AppPath = "C:\Program Files\ApexDC++\" ;path of app executable
$AppProcess = "ApexDC.exe" ;needed for capture filter
$AppRuleName = 'directconnect' ;will be the name of the folder pcaps are stored in
;should be same as the name of the .rule file in STA
;others
$DCTitle = "ApexDC++ "
$DCWinHandle = ""
$TimeToRun = Number($opt_t)


;Common Start Routines
;=====================
Call("_CommonStartup",1)

;Script Actions
;==============
;Run DC++
$DCWinHandle = Call("_LaunchApp", $AppPath & $AppProcess, $DCTitle)
Sleep(2000)
Call("_MaximizeWin",$DCWinHandle)

;download random file lists
Call('_MouseMoveNClick',$DCTitle,"[CLASS:FlatTabCtrl; INSTANCE:1]",370,10,"left")
Call('_MouseMoveNClick',$DCTitle,"[CLASS:SysHeader32; INSTANCE:1]",140,10,"left")
Call('_MouseMoveNClick',$DCTitle,"[CLASS:SysHeader32; INSTANCE:1]",140,10,"left")
;put multiple results for download
For $count = 0 To 15
	Sleep(300)
	Call('_MouseMoveNClick',$DCTitle,"[REGEXPCLASS:ATL:*; INSTANCE:1]",50,36+(20*$count),"",2)
Next
;wait for specified time
Sleep($TimeToRun)
;Close DC++
;Call("_CloseWin",$soulSeekWinHandle)
ProcessClose($AppProcess)

;Common End Routines
;===================
Call("_CommonEnd")

Exit