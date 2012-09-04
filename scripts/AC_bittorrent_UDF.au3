;; UDF for Application Class: Bittorrent ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#include <AC_bittorrent_DEF.au3>
#include <AC_web_UDF.au3>
#include<file.au3>
;===============================================================================
;
; Function Name:    _bt_GetTorrent()
; Description:      Download a Specified torrent
;
; Parameter(s):		$TorrentToGet	::	A simple text search term for the torrent
;										you want to download, e.g.
;										dexter s01e01
;										nobrowser, if you want to run already
;										downloaded torrent
;
; Requirement(s):
; Return Value(s):
;
; Author(s):        Hammad Fauz
;
;===============================================================================

Func _bt_GetTorrent($_bt_TorrentToGet)
	$_bt_TorrentToGetPlus = StringRegExpReplace($_bt_TorrentToGet," ","{+}")
	If $_bt_TorrentToGetPlus = "nobrowser" Then
		;Get torrent file name
		$_bt_filhandl=FileFindFirstFile($_bt_downloaddir & "*.torrent")
		$_bt_torrentfile=FileFindNextFile($_bt_filhandl)
	Else
		;Launch Google Chrome with torrentz search
		Call("_wb_OpenWithPage","torrentz.eu/search?f=" & $_bt_TorrentToGetPlus,$_bt_TorrentToGet & $_bt_TorrentzResultTitle)
		;Download specified torrent
		;;Delete any previous torrent files in download directory
		FileDelete($_bt_downloaddir & "*.torrent")
		;;Select the first result
		Sleep(300)
		If Call("_wb_SelectLink","verified")=0 Then
			Call("_ErrorNQuit","could not find verified text","_bt_GetTorrent")
		EndIf
		Sleep(300)
		ControlSend($_wb_chromeWinHandle,"","[CLASS:Chrome_RenderWidgetHostHWND; INSTANCE:1]","{TAB}{ENTER}")
		Sleep(300)
		Opt("WinTitleMatchMode",2)
		Call("_wb_wait4PageLoad",$_bt_TorrentzDownloadTitle)
		Opt("WinTitleMatchMode",1)
		;;Select piratebay as tracker (Should it be a command line option?)
		Sleep(300)
		if Call("_wb_SelectLink","thepiratebay.org")=0 Then
			$_bt_TorrentToGetPercent = StringRegExpReplace($_bt_TorrentToGet," ","{%}20")
			Call("_wb_GoToPage","http://thepiratebay.org/search/" & $_bt_TorrentToGetPercent & "/",$_bt_TPBTitle)
			Call("_wb_SelectLink","ULed by")
			ControlSend($_wb_chromeWinHandle,"","[CLASS:Chrome_RenderWidgetHostHWND; INSTANCE:1]","{TAB 8}{ENTER}")
;			_FileWriteLog($LogDir & $logFile, "Link does not exist: Exiting...")
;			Call("_ErrorNQuit",1)
		Else
			Sleep(300)
			ControlSend($_wb_chromeWinHandle,"","[CLASS:Chrome_RenderWidgetHostHWND; INSTANCE:1]","{ENTER}")
			ControlSend($_wb_chromeWinHandle,"","","{CTRLDOWN}{SHIFTDOWN}{TAB}{SHIFTUP}{CTRLUP}")
			ControlSend($_wb_chromeWinHandle,"","","{CTRLDOWN}w{CTRLUP}")
			sleep(300)
		EndIf
		Opt("WinTitleMatchMode",2)
		Call("_wb_wait4PageLoad",$_bt_TPBTorrentTitle)
		;;Download torrent file
		Opt("WinTitleMatchMode",1)
		sleep(300)
		If Call("_wb_SelectLink","download this torrent")=0 Then
			Call("_ErrorNQuit","could not find download this torrent link","_bt_GetTorrent")
		EndIf
		Sleep(300)
		ControlSend($_wb_chromeWinHandle,"","[CLASS:Chrome_RenderWidgetHostHWND; INSTANCE:1]","{ENTER}")
		Sleep(5000)
		;Close Chrome
		Call("_wb_ExitChrome")
		;Get torrent file name
		$_bt_filhandl=FileFindFirstFile($_bt_downloaddir & "*.torrent")
		$_bt_torrentfile=FileFindNextFile($_bt_filhandl)
	EndIf
EndFunc
