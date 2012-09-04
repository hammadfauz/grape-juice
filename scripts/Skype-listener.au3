; Script Version: 1.3
;==Summary======================================
;Setup function to deal with pesky update popup
;Run Skype
;Sign in with specified username
;wait for call
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
Global $opt_v = "wichorus3"	;username for sign in
Global $opt_p = "test123"	;password for user
Global $opt_u = "wichorus5"	;username to interact with
Global $opt_a = "file"		;action (video|file)
Global $opt_t = 60000	;time to run
;Reading Command Line arguments for variable initialization
Call("_ReadCmdLineParams", ":v:p:u:a:t")

;Local Variable Declarations
;===========================
;Commons but modify for each script
$AppPath="C:\Program Files\Skype\Phone\"	;Location of app executable
$AppProcess="skype.exe"	;needed for capture filter
$AppRuleName='skype'		;will be the name of the folder pcaps are stored in
							;should be same as the name of the .rule file in STA
;others
$UserName=$opt_v
$UserPass=$opt_p
$FriendName=$opt_u
$action=$opt_a
$TimeToWait=Number($opt_t)
$SkypeTitle="[CLASS:TLoginForm]"
$SkypeSignedInTitle="[CLASS:tSkMainForm]"
$SkypeWinHandle=""

;Common Start Routines
;=====================
Call("_CommonStartup",1)

;Script Actions
;==============
;Setup function to deal with pesky update popup
AdlibRegister("KillUpdate")
Func KillUpdate()
	If WinExists("Skype™ - Update") Then
		ControlSend("Skype™ - Update","","","{ESC}")
	EndIf
EndFunc
;Run Skype
local $Return_Value[2]
Opt("SendKeyDelay",20)
Opt("WinTitleMatchMode",1)
$SkypeWinHandle=Call("_LaunchApp",$AppPath & $AppProcess,$SkypeTitle)
sleep(2000)
Opt("WinTitleMatchMode",1)
Sleep(500)
;Sign in with specified username
$NumTries=0
While Not WinExists("Skype™ ")
	Call("_MouseMoveNClick",$SkypeTitle,"[CLASS:Internet Explorer_Server; INSTANCE:1]",45,200)
	Sleep(1000)
	Call("_MouseMoveNClick",$SkypeTitle,"[CLASS:Internet Explorer_Server; INSTANCE:1]",45,200)
	Sleep(1000)
	ControlSend($SkypeTitle,"","","{CTRLDOWN}a{CTRLUP}{DEL}" & $UserName & "{TAB 2}")
	Sleep(1000)
	ControlSend($SkypeTitle,"","",$UserPass & "{ENTER}")
	Sleep(500)
	If ProcessExists("Chrome.exe") Then
		ProcessClose("Chrome.exe")
	EndIf
	Sleep(30000)
	$NumTries=$NumTries+1
	If $NumTries=5 Then
		Call("_ErrornQuit","Could not sign in to Skype","WinExists")
	EndIf
WEnd
Func CallRecv()
	If WinExists("[CLASS:TCallNotificationWindow]") Then
		Call("_MouseMoveNClick","[CLASS:TCallNotificationWindow]","",135,90)
	EndIf
EndFunc
Func FileRecv()
	if WinExists("[CLASS:TCallNotificationWindow]") Then
		AdlibUnRegister("FileRecv")
		Sleep(30000)
		Call("_MouseMoveNClick",$SkypeSignedInTitle,"[CLASS:TConversationsControl; INSTANCE:1]",40,50)
		Opt("SendKeyDelay",20)
		ControlSend($SkypeSignedInTitle,"","",$FriendName & "{ENTER}")
		Sleep(500)
		Call("_MouseMoveNClick",$SkypeSignedInTitle,"[CLASS:TChatContentControl; INSTANCE:1]",170,205)
	EndIf
EndFunc
;wait for call|file
If $action="file" Then
	AdlibRegister("FileRecv")

ElseIf $action="video" Then
	AdlibRegister("CallRecv")
EndIf
Sleep($TimeToWait)
if $action="file" Then
	AdlibUnRegister("FileRecv")
ElseIf $action="video" Then
	AdlibUnRegister("CallRecv")
EndIf
ProcessClose($AppProcess)
;Common End Routines
;===================
Call("_CommonEnd")

exit