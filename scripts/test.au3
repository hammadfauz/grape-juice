#include <file.au3>
#include <../DPI_UDF.au3>
Call("_MouseMoveNClick","Skype™ ","[CLASS:TChatContentControl; INSTANCE:1]",165,20)
;Call('_MouseMoveNClick',"DC++","[CLASS:FlatTabCtrl; INSTANCE:1]",50,7,"left")
;Call('_MouseMoveNClick',"DC++ ","[CLASS:ATL:00502AC8; INSTANCE:1]",50,36+20,"",2)
;Call("_unConfigDataPlane")
;Call("_PauseUntilControlChange","Google Talk","[CLass:#32770; INSTANCE:1]")
;Call("_CommonStartup",1)
;Call("_DbgPrint","hello","world")
;sleep(10000)
;Call("_CommonEnd")
;AdlibRegister("_ConnectivityTest")
;Func _ConnectivityTest()
;	If Not Ping("8.8.8.8") Then
;		Call("_ErrorNQuit","Connectivity test failed","_ConnectivityTest")
;	EndIf
;EndFunc
;Sleep(30000)
;Call("_unConfigDataPlane")
;Sleep(30000)
;Call("_DbgPrint","Should never print this","_connectivityTest")

;$coords2[0]=0
;$coords2[1]=0
;MouseMove($coords[0]+$coords2[0],$coords[1]+$coords2[0],5)
;#include <..\DPI_UDF.au3>
;Call('_MouseMoveNClick',"SoulSeek ","[CLASS:SysTabControl32; INSTANCE:2]",50,30+(20*0),"",2)
;	$finalcoordx = $coordx + $wincoords[0] + $coords1[0]
;	$finalcoordy = $coordy + $wincoords[1] + $coords1[1]
;	MouseMove($finalcoordx, $finalcoordy, 5)
;	MouseClick($ClickType,"","",$clicktimes)
#cs
Global $test = "bleh"
Switch $test
	case "live"
		ConsoleWrite("I LIVE!" & @CRLF)
	case "die","zombie"
		ConsoleWrite("I am (UN)DEAD." & @CRLF)
	Case Else
		ConsoleWrite("I KNOW NOT WHAT I AM." & @CRLF)
EndSwitch

$vid="blank space"
$SearchTerm=StringRegExpReplace($vid," ","{+}")
ConsoleWrite($SearchTerm)

Run("C:\Program Files\Anatomic P2P\anatomicgui.exe","C:\Program Files\Anatomic P2P")
#ce
#cs
Func checkchange($wintitle,$tcoordx,$tcoordy,$bcoordx,$bcoordy)
	WinActivate($wintitle)
	Sleep(200)
	$wincoords=WinGetCaretPos()
	$finaltcoordx=$wincoords[0]+$tcoordx
	$finaltcoordy=$wincoords[1]+$tcoordy
	$finalbcoordx=$wincoords[0]+$bcoordx
	$finalbcoordy=$wincoords[1]+$bcoordy
	$oldchecksum=0
	$newchecksum=0
	Do
		$oldchecksum=$newchecksum
		$newchecksum=PixelChecksum($finaltcoordx,$finaltcoordy,$finalbcoordx,$finalbcoordy)
		ConsoleWrite("loading" & @CRLF)
		Sleep(1000)
	Until $oldchecksum=$newchecksum
	ConsoleWrite("Done!" & @CRLF)
EndFunc
Opt("WinTitleMatchMode",2)
checkchange("Google Chrome",20,20,35,35)
Opt("WinTitleMatchMode",1)
#ce
#cs
Func moveNclick($wintitle,$coordx,$coordy)
	WinActivate($wintitle)
	sleep(2000)
	$wincoords=WinGetCaretPos()
	$coords1=ControlGetPos($wintitle,"","[CLASS:MFCReportCtrl; INSTANCE:2]")
	;ConsoleWrite($coords1 & @CRLF)
	$finalcoordx=$coordx + $wincoords[0] + $coords1[0]
	$finalcoordy=$coordy + $wincoords[1] + $coords1[1]
	MouseMove($finalcoordx,$finalcoordy,5)
	Sleep(3000)
	MouseClick("left")
	Sleep(500)
EndFunc
Opt("WinTitleMatchMode",2)
$wintitles="[Class:PPLiveGUI]"
moveNclick($wintitles,0,0)
Opt("WinTitleMatchMode",1)
#ce
#cs
Sleep(500)
Send("{UP}{ENTER}")
Sleep(500)
ControlSend("Remove Torrent","","","{ENTER}")
Sleep(7000)
#ce