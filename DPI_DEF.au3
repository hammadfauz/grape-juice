Global $opt_N="defaulttest"
Global $opt_R="default"
Global $TestCaseName=$opt_N
Global $logDir=""
Global $pcapDir=""

Global $timeStamp= @MON & @MDAY & @YEAR &"-" & @HOUR & @MIN & @SEC
Global $scriptNameNoExt=StringSplit(@ScriptName,".")
Global $logFile=$scriptNameNoExt[1] &  "-ERR" & ".txt"
Global $DbgLogFile=$scriptNameNoExt[1] &  "-DBG" & ".txt"
Global $msncapFile=$scriptNameNoExt[1] &  "-" & $timeStamp & ".cap"
Global $pcapFile=$scriptNameNoExt[1] &  "-" & $timeStamp & ".pcap"

Global $msNetMonitorDir="C:\Program Files\Microsoft Network Monitor 3\"
Global $msNetMonitorAppName="nmcap"

Global $editcapexe='"C:\Program Files\Wireshark\editcap.exe"'

Global $AppName=""
Global $AppProcess=""
Global $AppRuleName="unclassified"

Global $DebugPriority=0
Global $PingInfraction=0