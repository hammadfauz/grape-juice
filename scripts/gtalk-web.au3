; Script Version: 1.3
;==Summary======================================
;Open gmail in chrome
;Sign in with specified username
;select specified contact to call
;Wait for specified time
;End call
;Quit chrome
;===============================================

#include <file.au3>
#include <Date.au3>
#include <..\DPI_UDF.au3>
#include <AC_web_UDF.au3>

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Specify directives for use by linux host here as shown ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;serverdirective:helpmsg:-This script requires a listener script to run on a:
;serverdirective:helpmsg:different testmac:
;serverdirective:helpmsg:-you will be asked to configure the listener first:
;serverdirective:helpmsg:-make sure time is 600000 + actual call duration:
;serverdirective:helpmsg:-network scenario for listener machine needs to be
;serverdirective:helpmsg:different than the caller machine scenario:
;serverdirective:chat:gtalk-web-listener:

;Command Line Parameters
;=======================
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Note: Do NOT specify n,r as option switches,  ;;
;; it is used for testcase name, network scenario ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Default Values
Global $opt_v = "wichorus01"	;username for sign in
Global $opt_p = "my_wic123"	;password for user
Global $opt_u = "wichorus02"	;user to chat with
Global $opt_a = "video"			;specify action chat|video
Global $opt_t = 30000			;duration of call in millisec
;Reading Command Line arguments for variable initialization
Call("_ReadCmdLineParams", ":v:p:u:a:t")

;Local Variable Declarations
;===========================
;Commons but modify for each script
$AppPath="C:\Program Files\Google\Google Talk\"	;Location of app executable
$AppProcess="googletalkplugin.exe"	;needed for capture filter
$AppRuleName='gtalk'		;will be the name of the folder pcaps are stored in
							;should be same as the name of the .rule file in STA
;others
$UserName=$opt_v
$UserPass=$opt_p
$FriendName=$opt_u
$Wait=Number($opt_t)
$action=$opt_a
$GmailTitle="Gmail"

;Common Start Routines
;=====================
Call("_CommonStartup",1)

;Script Actions
;==============
;Open Gmail in chrome
Call("_wb_OpenWithPage","mail.google.com",$GmailTitle)
;Sign in with specified username
ControlSend($GmailTitle,"","","{CTRLDOWN}a{CTRLUP}" & $UserName & "{TAB}")
Sleep(1000)
ControlSend($GmailTitle,"","",$UserPass &"{ENTER}")
Call("_wb_wait4PageLoad","Gmail - Inbox")

;select specified contact to call
While Not ProcessExists($AppProcess)
	Sleep(1000)
WEnd
While PixelGetColor(27,414) <> 0x32B40D
	Sleep(1000)
	Call("_DbgPrint","client not yet active","gtalk-web")
WEnd
Sleep(2000)
Call("_MouseMoveNClick",$GmailTitle,"[CLASS:Chrome_RenderWidgetHostHWND; INSTANCE:1]",30,300)
Sleep(500)
ControlSend($GmailTitle,"","",$FriendName)
Sleep(1000)
ControlSend($GmailTitle,"","","{RIGHT}{ENTER}")
Sleep(1000)
$time=0
Switch $action
	Case "chat"

		While $time < $Wait/1000
			$sleeptime=Random(1000,2000,1)
			Sleep($sleeptime)
			For $length = 0 To Random(10,30,1)
				$letter=chr(Random(97,122,1))
				ControlSend($GmailTitle,"","",$letter)
			Next
			ControlSend($GmailTitle,"","","{ENTER}")
			$time=$time+1
		WEnd
	Case "video"
		While $time < 11
			$sleeptime=Random(500,1000,1)
			Sleep($sleeptime)
			For $length = 0 To Random(10,30,1)
				$letter=chr(Random(97,122,1))
				ControlSend($GmailTitle,"","",$letter)
			Next
			ControlSend($GmailTitle,"","","{ENTER}")
			$time=$time+1
		WEnd
		$Coords=WinGetPos($GmailTitle)
		Call("_MouseMoveNClick",$GmailTitle,"[CLASS:Chrome_RenderWidgetHostHWND; INSTANCE:1]",$Coords[2]-240,$Coords[3]-360)
		Sleep(5000)
		Call("_MouseMoveNClick",$GmailTitle,"[CLASS:NativeWindowClass; INSTANCE:1]",90,120)
		Call("_MouseMoveNClick",$GmailTitle,"[CLASS:NativeWindowClass; INSTANCE:1]",90,120)
		;Wait for specified time
		Sleep($Wait)
EndSwitch

;End call
Call("_MouseMoveNClick",$GmailTitle,"[CLASS:NativeWindowClass; INSTANCE:1]",35,170)

;Quit chrome
Call("_wb_GoToPage","https://mail.google.com/mail/?logout&hl=en","Gmail:")
ProcessClose("Chrome.exe")

;Common End Routines
;===================
Call("_CommonEnd")

exit