; Script Version: 1.3
;==Summary======================================
;Setup function to deal with pesky update popup
;Run gtalk
;Sign in with specified username
;select specified contact to call
;Wait for specified time
;End call
;Quit gtalk
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
;serverdirective:chat:gtalk-client-listener:

;Command Line Parameters
;=======================
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Note: Do NOT specify n,r as option switches,  ;;
;; it is used for testcase name, network scenario ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Default Values
Global $opt_v = "wichorus01"	;username for sign in
Global $opt_p = "my_wic123"	;password for user
Global $opt_u = "wichorus02"	;user to chat with
Global $opt_a = "audio"			;action to perform audio|chat|file
Global $opt_t = 30000			;duration of call in millisec
;Reading Command Line arguments for variable initialization
Call("_ReadCmdLineParams", ":v:p:u:a:t")

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
$FriendName=$opt_u
$wait=Number($opt_t)
$action=$opt_a
$gtalkTitle="Google Talk"
$SkypeSignedInTitle="Skype™ "
$SkypeChatTitle=$FriendName
$SkypeWinHandle=""

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
$SkypeWinHandle=Call("_LaunchApp",$AppPath & $AppProcess,$gtalkTitle)
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
ControlGetHandle($gtalkTitle,"","[CLASS:Contact List View; INSTANCE:1]")
Sleep(1000)
Call("_PauseUntilControlChange",$gtalkTitle,"[CLASS:Main View; INSTANCE:1]")
Sleep(1000)
Call("_PauseUntilControlChange",$gtalkTitle,"[CLASS:Main View; INSTANCE:1]")
Sleep(1000)
Call("_PauseUntilControlChange",$gtalkTitle,"[CLASS:Main View; INSTANCE:1]")
Sleep(1000)
Call("_PauseUntilControlChange",$gtalkTitle,"[CLASS:Main View; INSTANCE:1]")
Call("_DbgPrint","first time change")
;ControlGetHandle($gtalkTitle,"","[CLASS:Contact List View; INSTANCE:1]")
;While @error = 1
;	Sleep(1000)
;	Call("_DbgPrint","[CLASS:Contact List View; INSTANCE:1] not exist yet")
;	ControlGetHandle($gtalkTitle,"","[CLASS:Contact List View; INSTANCE:1]")
;WEnd
;select specified contact to call
Sleep(2000)
ControlSend($gtalkTitle,"","[CLASS:RichEdit20W; INSTANCE:3]",$FriendName)
Sleep(1500)
Call("_MouseMoveNClick",$gtalkTitle,"[CLASS:Contact List View; INSTANCE:1]",50,20)
Sleep(500)
Switch $action
	Case "audio"
		Call("_MouseMoveNClick","[CLASS:Chat View]","[CLASS:Chat Link Bar; INSTANCE:1]",30,15)
	Case "file"
		Call("_MouseMoveNClick","[CLASS:Chat View]","[CLASS:Chat Link Bar; INSTANCE:1]",120,15)
		Sleep(300)
		ControlSend("Sharing with","","[CLASS:Edit; INSTANCE:1]","C:\Users\Administrator\Downloads\abigfile{ENTER}")
EndSwitch
;Wait for specified time
Sleep($wait)
;End call
Call("_MouseMoveNClick","[CLASS:Chat View]","[CLASS:Chat Link Bar; INSTANCE:1]",45,15)
sleep(1000)
;Quit gtalk
AdlibUnRegister("KillInvite")
ProcessClose($AppProcess)
;Common End Routines
;===================
Call("_CommonEnd")

exit