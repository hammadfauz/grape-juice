; Collection of User-Defined Functions for DPI Apps Automation
;===============================================================================
#include <array.au3>
#include <DPI_DEF.au3>
;===============================================================================
;
; Function Name:    _CreateFolder()
; Description:      Create Folders for logs and pcaps
;
; Parameter(s):
;
; Requirement(s):
; Return Value(s):
;
; Author(s):        Hammad Fauz
;
;===============================================================================

Func _CreateFolder()
If not FileExists($LogDir) Then
	;DirRemove($logDir,1)
	DirCreate($LogDir)
EndIf
If not FileExists($PcapDir) Then
	;DirRemove($PcapDir,1)
	DirCreate($PcapDir)
EndIf
EndFunc

;===============================================================================
; Function Name:    _ErrorNQuit()
; Description:      To log error and Quit the script
;
; Parameter(s):		$ErrMsg		;message string to log
;					$FuncName	;function in which the error occured
;
; Requirement(s):
; Return Value(s):
;
; Author(s):        Hammad Fauz
;
;===============================================================================

Func _ErrorNQuit($ErrMsg="undef",$FuncName="undef")
	if $ErrMsg = "undef" Then
		ConsoleWrite("Undefined Error!" & @CRLF)
		FileWrite($LogDir & $LogFile,$scriptNameNoExt[1] & ": Undefined Error!" & @CRLF)
	Else
		ConsoleWrite("in "& $FuncName & ": " & $ErrMsg & @CRLF)
		FileWrite($LogDir & $LogFile,$scriptNameNoExt[1] & ": in " & $FuncName & ": " & $ErrMsg & @CRLF)
	EndIf
	ProcessClose($AppProcess)
	Call("_StopMSNetMonitor")
	Call("_unConfigDataPlane")
	Exit
EndFunc

;===============================================================================
; Function Name:    _DbgPrint()
; Description:      To log error and Quit the script
;
; Parameter(s):		$DbgMsg		;message string to log
;					$FuncName	;function in which event occured
;
; Requirement(s):
; Return Value(s):
;
; Author(s):        Hammad Fauz
;
;===============================================================================

Func _DbgPrint($DbgMsg="undef",$FuncName="undef")
	if $DbgMsg = "undef" Then
		ConsoleWrite("Undefined Error!" & @CRLF)
		FileWrite($LogDir & $DbgLogFile,$scriptNameNoExt[1] & ": Undefined Breakpoint!" & @CRLF)
	Else
		ConsoleWrite("in " & $FuncName & ": " & $DbgMsg & @CRLF)
		$filewritestatus=FileWrite($LogDir & $DbgLogFile,$scriptNameNoExt[1] & ": in " & $FuncName & ": " & $DbgMsg & @CRLF)
		ConsoleWrite($filewritestatus&@CRLF)
	EndIf
EndFunc

;===============================================================================
;
; Function Name:    _LaunchApp()
; Description:      To launch an app from start menu.
;
; Parameter(s):		AppEecutable		::		path of app exe to run
;					WinTitle			::		expected window title to wait For
;
; Requirement(s):
; Return Value(s):	Winhandle			::		handle for use by ControlSend()
;
; Author(s):        Hammad Fauz
;
;===============================================================================

Func _LaunchApp($AppExecutable, $AppWinTitle, $AppRunDir=@ScriptDir,$Timeout=30)
	Run($AppExecutable,$AppRunDir)
	If WinWait($AppWinTitle, "",$Timeout) Then
		$WinHandle=WinGetHandle($AppWinTitle)
		If @error Then
			call("_ErrorNQuit","Could not get winHandle","_LaunchApp")
		EndIf
		Return $WinHandle
	Else
		call("_ErrorNQuit","Launch failed, timed out","_LaunchApp")
	EndIf
EndFunc

;===============================================================================
;
; Function Group	Window Controls
; Function Name:    _MaximizeWin(),_MinimizeWin(), _CloseWin()
; Description:      Maximizes, Minimizes, Closes the window
;
; Parameter(s):		$WinHandle	;;	handle of the window being maximized
;
; Requirement(s):
; Return Value(s):
;
; Author(s):        Hammad Fauz
;
;===============================================================================

Func _MaximizeWin($WinHandle)
	ControlSend($WinHandle,"","","{ALTDOWN}{SPACE}{ALTUP}{UP 2}{ENTER}")
EndFunc

Func _MinimizeWin($WinHandle)
	ControlSend($WinHandle,"","","{ALTDOWN}{SPACE}{ALTUP}{UP 3}{ENTER}")
EndFunc

Func _CloseWin($WinHandle)
	Local $_CloseWinTries=0
	Do
		ControlSend($WinHandle,"","","{ESC}")
		sleep(100)
		ControlSend($WinHandle,"","","{ALTDOWN}{SPACE}{ALTUP}{UP}{ENTER}")
		sleep(1000)
		$_CloseWinTries=$_CloseWinTries+1
		if $_CloseWinTries=15 Then
			ProcessClose($AppProcess)
		EndIf
	Until Not WinExists($WinHandle)
EndFunc

;===============================================================================
;
; Function Name:    _StartMSNetMonitor()
; Description:      Starts the Microsoft NetMonitor
;
; Parameter(s):		process name for app being monitored
;
; Requirement(s):
; Return Value(s):
;
; Author(s):        Hammad Fauz
;
;===============================================================================

Func _StartMSNetMonitor($AppProcess,$FallbackBit=0)
	Run("cmd")
	Sleep(1000)
	WinWait("Administrator: C:\Windows\system32\cmd.exe")
	WinActivate("Administrator: C:\Windows\system32\cmd.exe" )
	WinWaitActive("Administrator: C:\Windows\system32\cmd.exe","")
	If $FallbackBit = 0 Then
		$cmd = ($msNetMonitorAppName & " /network * /capture " & _
			"contains (Conversation.ProcessName,'" & $AppProcess & "')" & _
			" /CaptureProcesses /File " & $pcapDir & $msncapFile & _
			" /stopwhen /frame (ipv4.destinationaddress == 1.2.3.4)" &"{ENTER}")
	Else
		$cmd = ('"C:\Program Files\Wireshark\tshark.exe" -i 2 -p -f "ip ' & _
		'and not ip6 and not arp and not icmp and not icmp6 and not igmp ' & _
		'and not udp port 1900 and not udp port 5355 and not udp port 67 ' & _
		'and not udp port 567 and not tcp port 3389 and not udp port 5353 '& _
		'and not udp port 137 and not udp port 138 and not udp port 17500 '& _
		'and not udp port 1901 and not udp port 53 and not tcp port 5900" -w ' & $PcapDir & $pcapFile & "{ENTER}")
	EndIf
	sleep(1000)
	Send($cmd)
EndFunc

;===============================================================================
;
; Function Name:    _StopMSNetMonitor()
; Description:      Stops the MicrosoftNetMonitor capture
;
; Parameter(s):
;
; Requirement(s):
; Return Value(s):
;
; Author(s):        Hammad Fauz
;
;===============================================================================

Func _StopMSNetMonitor()
	if ProcessExists("nmcap.exe") Then
		run("ping -n 1 1.2.3.4")
		WinWait("Administrator: C:\Windows\system32\cmd.exe")
		sleep(2000)
		WinActivate("Administrator: C:\Windows\system32\cmd.exe")
		Sleep(1000)
		Send("exit{ENTER}")
		sleep(1000)
		run($editcapexe & " -T ether -F libpcap " & $pcapDir & $msncapFile & " " & $pcapDir & $pcapFile)
		sleep(300)
	Else
		WinClose('Administrator: C:\Windows\system32\cmd.exe - "C:\Program Files\Wireshark\tshark.exe"')
	EndIf
EndFunc

;===============================================================================
;
; Function Name:    _ReadCmdLineParams($input_format)
; Description:      Reads commandline parameters as specified by $input_format
;
; Parameter(s):
;  $input_format:   String of form :a:b:c:d
;					where a, b, c and a are switches to specify different values
;
; Requirement(s):   All the argument variables which are to be set should be global
;                   or should be visible to this function
;
; Return Value(s):  none
;
; Author(s):        Hammad Fauz
;
;===============================================================================

Func _ReadCmdLineParams($input_format)

	;splits the input string into characters, the first index of $input_format
	;($input_format[0]) will contain the number of characters followed by one
	;character at each index location
	$input_format = StringSplit($input_format, "")
	$i = 1;

	while ($i <= $input_format[0])

		if ($input_format[$i] == ":") Then

			For $j = 1 To $cmdline[0]

				If $cmdline[$j] == "-" & $input_format[$i + 1] Then

					;check if next argument is also - when a value is expected
					if ($j + 1 <= $cmdline[0]) Then
						;;Stip white space from the begining and end of the input
						;;Not alway nessary let it in just in case
						If StringLeft($cmdline[$j + 1], 1) == "-" Then
							_cmdLineHelpMsg()
							;exiting the program because of wrong input arguments
							Exit
						EndIf
					EndIf

					$variable_name = "opt_" & $input_format[$i + 1]

					if (IsDeclared($variable_name)) Then
						Assign($variable_name, $cmdline[$j + 1])
						ExitLoop
					EndIf
				EndIf
			Next
			$i = $i + 1;
		Else
			For $j = 1 To $cmdline[0]

				If $cmdline[$j] == "-" & $input_format[$i] Then
					$variable_name = "opt_" & $input_format[$i]
					if (IsDeclared($variable_name)) Then
						Assign($variable_name, 1)
						ExitLoop
					EndIf

				EndIf
			Next
		EndIf
		$i = $i + 1
	WEnd
EndFunc   ;==>ReadCmdLineParams
;TODO script specific help msg
Func _cmdLineHelpMsg()
	ConsoleWrite('A better way to get the command line parameters' & @LF & @LF & _
					'Syntax:' & @tab & 'cmdLineForBlog.exe [options]' & @LF & @LF & _
					'Default:' & @tab & 'Display help message.' & @LF & @LF & _
					'Required Options:' & @LF & _
					'-h [message]' & @tab & ' Message Header' & @LF & _
					'-b [message]' & @tab & ' Message Body' & @LF & _
					@LF & _
					'Optional Options:' & @LF & _
					'-x ' & @tab & 'Flag X' & @lf & _
					'-y' & @tab &  'Flag Y' & @lf)
	Exit
EndFunc

;===============================================================================
;
; Function Group	Common routines
; Function Name:    _CommonStartup(), _CommonEnd()
; Description:      performs common startup and end routines
;
; Parameter(s):
;
; Requirement(s):
; Return Value(s):
;
; Author(s):        Hammad Fauz
;
;===============================================================================

Func _CommonStartup($FallbackBit=1)
	Call("_ReadCmdLineParams", ":N:R")
	$TestCaseName=$opt_N
	$Scenario=$opt_R
	$logDir= @ScriptDir & "\..\output\" & $TestCaseName & "\logs\"
	$pcapDir=@ScriptDir & "\..\output\" & $TestCaseName & "\pcaps\" & $AppRuleName & "\"
	Call("_ConfigDataPlane",$Scenario)
	AdlibRegister("_ConnectivityTest",15000)
	Call("_CreateFolder")
	call("_StartMSNetMonitor",$AppProcess,$FallbackBit)
	MouseMove(0,0,5) ;avoid any mouse-over conflics
EndFunc

Func _CommonEnd()
	AdlibUnRegister("_ConnectivityTest")
	Call("_StopMSNetMonitor")
	Call("_unConfigDataPlane")	;to restore any changes made
EndFunc

;===============================================================================
;
; Function Name:    _ConnectivityTest()
; Description:      Quits if internet is not reachable
;
; Parameter(s):
;
; Requirement(s):
; Return Value(s):
;
; Author(s):        Hammad Fauz
;===============================================================================

Func _ConnectivityTest()
	If Not Ping("8.8.8.8") Then
		$PingInfraction=$PingInfraction+1
		if $PingInfraction = 6 Then
			Call("_ErrorNQuit","Connectivity test failed","_ConnectivityTest")
		EndIf
	Else
		$PingInfraction=0
	EndIf
EndFunc

;===============================================================================
;
; Function Name:    _ConfigDataPlane()
; Description:      Configures the data interface for different scenarios
;
; Parameter(s):		$_ConfigName	;Name of the configuration you need to use
;
; Requirement(s):
; Return Value(s):
;
; Author(s):        Hammad Fauz
;===============================================================================

Func _ConfigDataPlane($_ConfigName="default")
	RunWait("route delete 0.0.0.0 mask 0.0.0.0 192.168.3.1")
	Switch $_ConfigName
		case "connection 1"
			$_ip="192.168.1.2"
			$_gw="192.168.1.1"
		Case "connection 2"
			$_ip="192.168.2.2"
			$_gw="192.168.2.1"
		Case "default connection"
			$_ip="192.168.3.2"
			$_gw="192.168.3.1"
	EndSwitch
	Call("_DbgPrint","BP1","_ConfigDataPlane")
	RunWait('netsh interface ip set address name="Data Plane" static ' & $_ip & " 255.255.255.0 " & $_gw & " 1")
	Call("_DbgPrint","BP2","_ConfigDataPlane")
	RunWait('netsh interface ip set dns "Data Plane" static 8.8.8.8')
	Call("_DbgPrint","BP3","_ConfigDataPlane")
EndFunc

Func _unConfigDataPlane()
	Call("_DbgPrint","BP1","_unConfigDataPlane")
	Run('netsh interface ip set address name="Data Plane" static 169.254.0.1 255.255.255.252 169.254.1.1 1')
	Call("_DbgPrint","BP2","_unConfigDataPlane")
EndFunc
;===============================================================================
;
; Function Name:    _MouseMoveNClick()
; Description:      substitute for ControlClick()
;
; Parameter(s):		$WinHandle	;;	handle/title of window containing control
;					$Control	;;	control id
;					$coodx|y	;;	position of click wrt control position
;					$ClickType	;;	left|right|middle
;					$clicktimes	;;	number of clicks (default 1)
;					$clickside	;;	coordinates with respect to top|bottom
;
; Requirement(s):
; Return Value(s):
;
; Author(s):        Hammad Fauz
;
;===============================================================================

Func _MouseMoveNClick($WinHandle,$Control,$coordx,$coordy,$ClickType="left",$clicktimes=1,$clickside="top")
	WinActivate($WinHandle)
	$wincoords = WinGetCaretPos()
	$winPos = WinGetPos($WinHandle)
	If Not ControlGetHandle($WinHandle,"",$Control) Then
		Call("_ErrorNQuit","failed to get controlhandle for " & $Control,"_MouseMoveNClick")
	EndIf
	$coords1 = ControlGetPos($WinHandle, "", $Control)
	if $clickside="top" Then
		$finalcoordx = $coordx + $wincoords[0] + $coords1[0]
		$finalcoordy = $coordy + $wincoords[1] + $coords1[1]
	Else
		If $clickside="bottom" Then
			If $Control="" Then
				$finalcoordx = $winPos[0] + $winPos[2] - $coordx
				$finalcoordy = $winPos[1] + $winPos[3] - $coordy
			else
				$finalcoordx = $wincoords[0] + $coords1[0] + $coords1[2] - $coordx
				$finalcoordy = $wincoords[1] + $coords1[1] + $coords1[3] - $coordy
			EndIf
		EndIf
	EndIf
	MouseMove($finalcoordx, $finalcoordy, 5)
	MouseClick($ClickType,Default,Default,$clicktimes)
	Sleep(500)
EndFunc

;===============================================================================
;
; Function Name:    _PauseUntilControlChange()
; Description:      Pauses script execution until the specified control changes
;					in appearance
;
; Parameter(s):		$WinHandle	;;	handle/title of window containing control
;					$Control	;;	control id
;
; Requirement(s):
; Return Value(s):
;
; Author(s):        Hammad Fauz
;
;===============================================================================

Func _PauseUntilControlChange($WinHandle,$Control,$TimeOut=60)
	$positions=ControlGetPos($WinHandle,"",$Control)
	$HasNotChanged=PixelChecksum($positions[0],$positions[1],$positions[0]+$positions[2],$positions[1]+$positions[3])
	While PixelChecksum($positions[0],$positions[1],$positions[0]+$positions[2],$positions[1]+$positions[3])=$HasNotChanged Or $TimeOut<>0
		Call("_DbgPrint",PixelChecksum($positions[0],$positions[1],$positions[0]+$positions[2],$positions[1]+$positions[3]) & " " & $HasNotChanged,"_PauseUntilControlChange")
		Sleep(1000)
		$TimeOut=$TimeOut-1
	WEnd
	If $TimeOut=0 Then
		Call("_DbgPrint","Timed out after " & $TimeOut & " sec","_PauseUntilControlChange")
	EndIf
EndFunc


;===============================================================================
;
; Function Name:    _PauseUntilAreaChange()
; Description:      Pauses script execution until the specified area changes
;					in appearance
;
; Parameter(s):		$WinHandle	;;	handle/title of window containing area
;					$xTopLeft	;;	x-coordinate of topleft corner of area
;					$yTopLeft	;;	y-coordinate of topleft corner of area
;					$xBottomRight;; x-coordinate of bottomright corner
;					$yBottomRight;; y-coordinate of bottomright corner
;
; Requirement(s):
; Return Value(s):
;
; Author(s):        Hammad Fauz
;
;===============================================================================

Func _PauseUntilAreaChange($WinHandle,$xTopLeft,$yTopLeft,$xBottomRight,$yBottomRight,$TimeOut=60)
	$WinPosition=WinGetPos($WinHandle)
	$HasNotChanged=PixelChecksum($WinPosition[0]+$xTopLeft,$WinPosition[1]+$yTopLeft,$WinPosition[0]+$xBottomRight,$WinPosition[1]+$yBottomRight)
	While PixelChecksum($WinPosition[0]+$xTopLeft,$WinPosition[1]+$yTopLeft,$WinPosition[0]+$xBottomRight,$WinPosition[1]+$yBottomRight)=$HasNotChanged Or $TimeOut<>0
		Sleep(1000)
		$TimeOut=$TimeOut-1
	WEnd
	If $TimeOut=0 Then
		Call("_DbgPrint","Timed out after " & $TimeOut & " sec","_PauseUntilControlChange")
	EndIf
EndFunc