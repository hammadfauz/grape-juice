;; UDF for Application Class: Web(Chrome) ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#include <AC_web_DEF.au3>
#include <file.au3>
;===============================================================================
;
; Function Name:    _wb_OpenWithPage()
; Description:      Run Chrome Browser and load specified page
;
; Parameter(s):		$_wb_PageToOpen	::	url you need to open
;					$_wb_PageTitle	::	Window Title of Page
;
; Requirement(s):
; Return Value(s):
;
; Author(s):        Hammad Fauz
;
;===============================================================================

Func _wb_OpenWithPage($_wb_PageToOpen,$_wb_PageTitle)
	local $Return_Value[2]
	$_wb_chromeWinHandle=Call("_LaunchApp",$_wb_chromeExe,$_wb_ChromeTitle)
	sleep(500)
	WinMove($_wb_chromeWinHandle,"","","",1090,606)
	Call("_wb_GoToPage",$_wb_PageToOpen,$_wb_PageTitle)
EndFunc

;===============================================================================
;
; Function Name:    _wb_GoToPage()
; Description:      load specified page on already open Chrome
;
; Parameter(s):		$_wb_PageToOpen	::	url you need to open
;					$_wb_PageTitle	::	Window Title of Page
;
; Requirement(s):
; Return Value(s):
;
; Author(s):        Hammad Fauz
;
;===============================================================================

Func _wb_GoToPage($_wb_PageToOpen,$_wb_PageTitle)
	Sleep(300)
	ControlSend($_wb_ChromeWinHandle,"","[CLASS:Chrome_OmniboxView; INSTANCE:1]","{CTRLDOWN}a{CTRLUP}")
	sleep(300)
	Opt("SendKeyDelay",50)
	ControlSend($_wb_chromeWinHandle,"","[CLASS:Chrome_OmniboxView; INSTANCE:1]",$_wb_PageToOpen)
	Opt("SendKeyDelay",5)
	sleep(300)
	ControlSend($_wb_chromeWinHandle,"","[CLASS:Chrome_OmniboxView; INSTANCE:1]","{ENTER}")
	sleep(1500)
	Call("_wb_wait4PageLoad",$_wb_PageTitle)
EndFunc

;===============================================================================
;
; Function Name:    _wb_wait4PageLoad()
; Description:      wait for the page to load
;
; Parameter(s):		$_wb_PageTitle :: Title of webpage we are waiting for
;
; Requirement(s):
; Return Value(s):
;
; Author(s):        Hammad Fauz
;
;===============================================================================

Func _wb_wait4PageLoad ($_wb_PageTitle)
	WinActivate($_wb_ChromeWinHandle)
	Sleep(200)
	$wincoords=WinGetCaretPos()
	$finaltcoordx=$wincoords[0]+20
	$finaltcoordy=$wincoords[1]+20
	$finalbcoordx=$wincoords[0]+35
	$finalbcoordy=$wincoords[1]+35
	$firsttime=1
	$NumTries=0
	Do
		$oldchecksum=3152
		$newchecksum=4265
		$timeout=0
		if $firsttime=0 Then
			ConsoleWrite("RELOADING NOW. Timeout:" & $timeout & @CRLF)
			ControlSend($_wb_ChromeWinHandle,"","[CLASS:Chrome_OmniboxView; INSTANCE:1]","{CTRLDOWN}a{CTRLUP}")
			sleep(300)
			ControlSend($_wb_chromeWinHandle,"","[CLASS:Chrome_OmniboxView; INSTANCE:1]","{CTRLDOWN}c{CTRLUP}")
			sleep(300)
			ControlSend($_wb_chromeWinHandle,"","[CLASS:Chrome_OmniboxView; INSTANCE:1]","{CTRLDOWN}v{CTRLUP}")
			sleep(300)
			ControlSend($_wb_chromeWinHandle,"","[CLASS:Chrome_OmniboxView; INSTANCE:1]","{ENTER}")
		EndIf
		$firsttime=0
		Do
			$oldchecksum=$newchecksum
			$newchecksum=PixelChecksum($finaltcoordx,$finaltcoordy,$finalbcoordx,$finalbcoordy)
			Sleep(1000)
			$timeout=$timeout+1
			If $timeout=30 Then
				Call("_DbgPrint","Reloading " & $_wb_PageTitle & " Timeout=" & $timeout,"_wb_wait4PageLoad")
				ControlSend($_wb_ChromeWinHandle,"","[CLASS:Chrome_OmniboxView; INSTANCE:1]","{CTRLDOWN}a{CTRLUP}")
				sleep(300)
				ControlSend($_wb_chromeWinHandle,"","[CLASS:Chrome_OmniboxView; INSTANCE:1]","{CTRLDOWN}c{CTRLUP}")
				sleep(300)
				ControlSend($_wb_chromeWinHandle,"","[CLASS:Chrome_OmniboxView; INSTANCE:1]","{CTRLDOWN}v{CTRLUP}")
				sleep(300)
				ControlSend($_wb_chromeWinHandle,"","[CLASS:Chrome_OmniboxView; INSTANCE:1]","{ENTER}")
				$timeout=0
			EndIf
			Call("_DbgPrint",$oldchecksum & " " & $newchecksum,"_wb_wait4PageLoad")
		Until $oldchecksum==$newchecksum
	Until WinExists($_wb_PageTitle)
	$NumTries=$Numtries+1
	If $NumTries=10 Then
		Call("_ErrornQuit",$_wb_PageTitle & " failed to load after 10 tries","_wb_wait4PageLoad")
	EndIf
EndFunc

;===============================================================================
;
; Function Name:    _wb_SelectLink()
; Description:      Select link on page by finding text
;
; Parameter(s):		$_wb_TextToSearch :: text of link to select
;
; Requirement(s):
; Return Value(s): 			1 if link exists
;							0 if link does not exist
;
; Author(s):        Hammad Fauz
;
;===============================================================================

Func _wb_SelectLink($_wb_TextToSearch)
	ControlFocus($_wb_chromeWinHandle,"","[CLASS:Chrome_OmniboxView; INSTANCE:1]")
	ControlSend($_wb_chromeWinHandle,"","","{CTRLDOWN}f{CTRLUP}")
	sleep(500)
	if PixelGetColor(957,86) = 16737894 Then
		$Retval=0
	Else
		$Retval=1
	EndIf
	ControlSend($_wb_chromeWinHandle,"","[CLASS:ViewsTextfieldEdit; INSTANCE:1]",$_wb_TextToSearch & "{ESC}")
	Return $Retval
EndFunc

;===============================================================================
;
; Function Name:    _wb_ExitChrome()
; Description:      Close Chrome browser
;
; Parameter(s):
;
; Requirement(s):
; Return Value(s):
;
; Author(s):        Hammad Fauz
;
;===============================================================================

Func _wb_ExitChrome ()
	Call("_CloseWin",$_wb_chromeWinHandle)
	Sleep(300)
	if WinExists($_wb_ChromeWinHandle) Then
		ControlSend("Google Chrome","","","{ENTER}")
	EndIf
EndFunc

;TODO: Wait for download