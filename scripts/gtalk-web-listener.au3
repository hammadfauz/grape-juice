; Script Version: 1.3
;==Summary======================================
;Open gmail in chrome
;Sign in with specified username
;Wait for call
;===============================================

#include <file.au3>
#include <Date.au3>
#include <..\DPI_UDF.au3>
#include <AC_web_UDF.au3>

;Command Line Parameters
;=======================
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Note: Do NOT specify n,r as option switches,  ;;
;; it is used for testcase name, network scenario ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Default Values
Global $opt_v = "wichorus02"	;username for sign in
Global $opt_p = "my_wic123"	;password for user
Global $opt_t = 60000	;time to wait for call
;Reading Command Line arguments for variable initialization
Call("_ReadCmdLineParams", ":v:p:t")

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
$TimeToRun=Number($opt_t)
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
;wait for call
AdlibRegister("RecvCall")
Func RecvCall()
	If Not WinExists("Gmail - Inbox") Then
		Opt("WinTitleMatchMode",2)
		Call("_MouseMoveNClick"," - Google Chrome","[CLASS:NativeWindowClass; INSTANCE:1]",35,170)
		Sleep(1000)
		WinSetState($GmailTitle,"",@SW_MINIMIZE)
	EndIf
EndFunc

Sleep($TimeToRun)
AdlibUnRegister("RecvCall")
;Quit chrome
Call("_wb_GoToPage","https://mail.google.com/mail/?logout&hl=en","Gmail:")
ProcessClose("Chrome.exe")

;Common End Routines
;===================
Call("_CommonEnd")

exit