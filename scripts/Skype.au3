; Script Version: 1.3
;==Summary======================================
;Setup function to deal with pesky update popup
;Run Skype
;Sign in with specified username
;select specified contact to call
;Wait for specified time
;End call
;Quit skype
;===============================================

#include <file.au3>
#include <Date.au3>
#include <..\DPI_UDF.au3>

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Specify directives for use by linux host here as shown ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;serverdirective:helpmsg:-This script requires a listener script to run on a:
;serverdirective:helpmsg:different testmac:
;serverdirective:helpmsg:-you will be asked to configure the listener first:
;serverdirective:helpmsg:-make sure time is 600000 + actual call duration:
;serverdirective:helpmsg:-network scenario for listener machine needs to be
;serverdirective:helpmsg:different than the caller machine scenario:
;serverdirective:chat:Skype-listener:

;Command Line Parameters
;=======================
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Note: Do NOT specify n,r as option switches,  ;;
;; it is used for testcase name, network scenario ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Default Values
Global $opt_v = "wichorus5"	;username for sign in
Global $opt_p = "test123"	;password for user
Global $opt_u = "wichorus3"	;user to chat with
Global $opt_a = "video"			;specify action file|video
Global $opt_t = 30000			;duration of call in millisec
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
$wait=Number($opt_t)
$action=$opt_a
$SkypeTitle="[CLASS:TLoginForm]"
$SkypeSignedInTitle="Skype™ "
$SkypeChatTitle=$FriendName
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
While Not WinExists($SkypeSignedInTitle)
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
;select specified contact to call
Call("_MouseMoveNClick",$SkypeSignedInTitle,"[CLASS:TConversationsControl; INSTANCE:1]",40,50)
ControlSend($SkypeSignedInTitle,"","",$FriendName & "{ENTER}")
Switch $action
	Case "video"
		Call("_MouseMoveNClick",$SkypeSignedInTitle,"[CLASS:TNonLiveCallToolbar; INSTANCE:1]",150,15)
	Case "file"
		Call("_MouseMoveNClick",$SkypeSignedInTitle,"[CLASS:TNonLiveCallToolbar; INSTANCE:1]",150,15)
		Sleep(2000)
		ControlSend($SkypeSignedInTitle,"","","{ALTDOWN}a{ALTUP}n")
		Sleep(15000)
		Call("_MouseMoveNClick",$SkypeSignedInTitle,"[CLASS:TNonLiveCallToolbar; INSTANCE:1]",230,15)
		sleep(500)
		Call("_MouseMoveNClick","[CLASS:TPlusMenuPopup]","[CLASS:TWidgetControl; INSTANCE:1]",60,25)
		Sleep(500)
		ControlSend("Send file to","","[CLASS:Edit; INSTANCE:1]","C:\Users\Administrator\Downloads\abigfile{ENTER}")
EndSwitch
;Wait for specified time
Sleep($wait)
;End call
ControlSend($SkypeSignedInTitle,"","","{ALTDOWN}a{ALTUP}n")
sleep(1000)
;Quit skype
AdlibUnRegister("KillUpdate")
ProcessClose($AppProcess)
;Common End Routines
;===================
Call("_CommonEnd")

exit