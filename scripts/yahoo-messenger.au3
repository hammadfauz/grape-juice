; Script Version: 1.3
;==Summary======================================
;Run Yahoo Messenger
;Sign in with specified username
;select specified contact to call
;Wait for specified time
;End call
;Quit Yahoo Messenger
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
Global $opt_v = "wichorus01"	;username for sign in
Global $opt_p = "my_wic123"	;password for user
Global $opt_u = "wichorus02"	;user to chat with
Global $opt_t = 30000			;duration of call in millisec
;Reading Command Line arguments for variable initialization
Call("_ReadCmdLineParams", ":v:p:u:t")

;Local Variable Declarations
;===========================
;Commons but modify for each script
$AppPath="C:\Program Files\Yahoo!\Messenger\"	;Location of app executable
$AppProcess="YahooMessenger.exe"	;needed for capture filter
$AppRuleName='yahoo'		;will be the name of the folder pcaps are stored in
							;should be same as the name of the .rule file in STA
;others
$UserName=$opt_v
$UserPass=$opt_p
$FriendName=$opt_u
$wait=Number($opt_t)
$yahooTitle="[CLASS:YahooBuddyMain]"
$YahooConvoTitle="[CLASS:CConvWndBase]"
$yahooWinHandle=""

;Common Start Routines
;=====================
Call("_CommonStartup",1)

;Script Actions
;==============
;Run Yahoo Messenger
local $Return_Value[2]
Opt("SendKeyDelay",20)
Opt("WinTitleMatchMode",1)
$yahooWinHandle=Call("_LaunchApp",$AppPath & $AppProcess,$yahooTitle)
sleep(2000)
Opt("WinTitleMatchMode",1)
Sleep(500)
;Sign in with specified username
ControlSend($yahooWinHandle,"","[CLASS:Edit; INSTANCE:1]","{CTRLDOWN}a{CTRLUP}" & $UserName)
ControlSend($yahooWinHandle,"","[CLASS:Edit; INSTANCE:2]",$UserPass & "{ENTER}")
ControlGetHandle($yahooWinHandle,"","[CLASS:SysListView32; INSTANCE:1]")
While @error = 1
	Sleep(1000)
	ControlGetHandle($yahooWinHandle,"","[CLASS:SysListView32; INSTANCE:1]")
WEnd
;select specified contact to call
ControlSend($yahooWinHandle,"","[CLASS:ATL:008AE990; INSTANCE:1]",$FriendName & "{ENTER}")
Sleep(5000)
WinActivate($YahooConvoTitle)
ControlSend($YahooConvoTitle,"","[CLASS:ATL:0088FCF8; INSTANCE:1]","{CTRLDOWN}j{CTRLUP}")
;Wait for specified time
Sleep($wait)
;End call
Call("_MouseMoveNClick",$YahooConvoTitle,"[CLASS:CMerlinWndBase; INSTANCE:1]",30,15)
sleep(1000)
;Quit Yahoo Messenger
ProcessClose($AppProcess)
;Common End Routines
;===================
Call("_CommonEnd")

exit