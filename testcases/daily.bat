::Test Case File, It contains paths of all the scripts that we want to run as part of our test case
::Command Line Arguments received by this script
::Description of Argument					Representation of Argument in this script
::Path of AutoIT scripts					%1
::Name of the Test Case						%2

::Start of Script
@echo off
cd ..\scripts
ping -n 5 127.0.0.1 >nul

::::::::::::::::::::::::::::::::::::
::         Streaming Apps         ::
::::::::::::::::::::::::::::::::::::

echo Generating Pcap for YouTube...
ping -n 5 127.0.0.1 >nul
youtube.au3 -N %0 -t 30000

echo Generating Pcap for Vimeo...
ping -n 5 127.0.0.1 >nul
vimeo.au3 -N %0 -t 30000

echo Generating Pcap for Veoh...
ping -n 5 127.0.0.1 >nul
veoh.au3 -N %0 -t 30000

echo Generating Pcap for Metacafe...
ping -n 5 127.0.0.1 >nul
metacafe.au3 -N %0 -t 30000

echo Generating Pcap for Dailymotion...
ping -n 5 127.0.0.1 >nul
dailymotion.au3 -N %0 -t 30000

echo Generating Pcap for Crunchyroll...
ping -n 5 127.0.0.1 >nul
crunchyroll.au3 -N %0 -t 30000

echo Generating Pcap for Megavideo...
ping -n 5 127.0.0.1 >nul
megavideo.au3 -N %0 -t 30000

echo Generating Pcap for NCAA...
ping -n 5 127.0.0.1 >nul
ncaa.au3 -N %0 -t 30000

echo Generating Pcap for Atom...
ping -n 5 127.0.0.1 >nul
atom.au3 -N %0 -t 30000

echo Generating Pcap for PPLive...
ping -n 5 127.0.0.1 >nul
pplive.au3 -N %0 -t 30000

::::::::::::::::::::::::::::::::::::
::            P2P Apps            ::
::::::::::::::::::::::::::::::::::::

echo Generating Pcap for uTorrent...
ping -n 10 127.0.0.1 >nul
uTorrent.au3 -N %0 -d "Nikita s01e06" -t 30000

echo Generating Pcap for Soulseek...
ping -n 5 127.0.0.1 >nul
soulseek.au3 -N %0 -t 30000

echo Generating Pcap for Vuze...
ping -n 5 127.0.0.1 >nul
VuZe.au3 -N %0 -d "the simpsons"-t 30000

echo Generating Pcap for BitComet...
ping -n 5 127.0.0.1 >nul
bitcomet.au3 -N %0 -d "frasier" -t 30000

echo Generating Pcap for Anatomic P2P...
ping -n 10 127.0.0.1 >nul
Anatomic-p2p.au3 -N %0 -d "arrested development" -t 30000

echo Generating Pcap for Arctic torrent...
ping -n 10 127.0.0.1 >nul
Arctic-torrent.au3 -N %0 -d "terra nova" -t 30000

echo Test Complete.



