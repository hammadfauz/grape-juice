; Script Version: 1.3
;==Summary======================================
;Setup function to deal with pesky update popup
;Run gtalk
;Sign in with specified username
;Wait for call
;===============================================

#include <file.au3>
#include <Date.au3>
#include <..\DPI_UDF.au3>

;Command Line Parameters
;=======================
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Note: Do NOT specify n,r as option switches,  ;;
;; it is used for testcase name, network scenario ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Default Values
Global $opt_v = "wichorus02"	;username for sign in
Global $opt_p = "my_wic123"	;password for user
Global $opt_t = 600000	;call duration in millisec
;Reading Command Line arguments for variable initialization
Call("_ReadCmdLineParams", ":v:p:t")

;Local Variable Declarations
;===========================
;Commons but modify for each script
$AppPath="C:\Program Files\Google\Google Talk\"	;Location of app executable
$AppProcess="googletalk.exe"	;needed for capture filter
$AppRuleName='gtalk'		;will be the name of the folder pcaps are stored in
							;should be same as the name of the .rule file in STA
;others
$UserName=$opt_v
$UserPass=$opt_p
$TimeToRun=Number($opt_t)
$gtalkTitle="Google Talk"
$gtalkWinHandle=""

;Common Start Routines
;=====================
Call("_CommonStartup",1)

;Script Actions
;==============
;Setup function to deal with pesky update popup
AdlibRegister("KillInvite")
Func KillInvite()
	If WinExists("Invite your friends to Google Talk") Then
		ControlSend("Invite your friends to Google Talk","","","{ESC}")
	EndIf
EndFunc
;Run gtalk
local $Return_Value[2]
Opt("SendKeyDelay",20)
Opt("WinTitleMatchMode",1)
$gtalkWinHandle=Call("_LaunchApp",$AppPath & $AppProcess,$gtalkTitle)
sleep(2000)
Opt("WinTitleMatchMode",1)
Sleep(500)
;Sign in with specified username
ControlSend($gtalkTitle,"","[CLASS:Edit; INSTANCE:1]","{CTRLDOWN}a{CTRLUP}" & $UserName)
Sleep(1000)
ControlSend($gtalkTitle,"","[CLASS:Edit; INSTANCE:2]",$UserPass &"{ENTER}")
Sleep(1000)

ControlSend($gtalkTitle,"","","{CTRLDOWN}a{CTRLUP}{DEL}" & $UserName & "{TAB 2}")
Sleep(1000)
ControlSend($gtalkTitle,"","",$UserPass & "{ENTER}")
Sleep(500)
While ControlGetHandle($gtalkTitle,"","[CLASS:Status View 2; INSTANCE:1]") = ""
	Sleep(1000)
WEnd

;wait for call
AdlibRegister("RecvCall")
Func RecvCall()
	If WinExists("Google Notification") Then
		Call("_MouseMoveNClick","Google Notification","",100,70)
	EndIf
EndFunc
Sleep($TimeToRun)
AdlibUnRegister("RecvCall")
AdlibUnRegister("KillInvite")
ProcessClose($AppProcess)
;Common End Routines
;===================
Call("_CommonEnd")

exit