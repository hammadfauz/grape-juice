grape-juice
===========

An AutoIt-based framework for building scripts to automate any apps in windows.
Pre-reqs: Microsoft network monitor, wireshark, AutoIt
How to use:
-----------
> Create an AutoIt script in the scripts/directory. Use template.au3  
> DPI_UDF.au3 has some useful functions that can be used in scripts  
> Create a test case in the testcases/ directory. The test case lists all the scripts you want to run for a specific test  
> Open a command line and run initiate_automation.bat with the appropriate arguments to run your test case. See initiate_automation.bat code for details on arguments  

What to expect:
---------------
> The application runs as specified in the the .au3 script  
> msnetmonitor runs to capture traffic generated by the application  
> the resulting .cap file is converted to a pcap file and stored in the location specified  

Coding conventions:
-------------------
> Use a sharp graphite HB pencil  
> Use CamelCase for variable and function names  
> Use single tabs for indentation  
> Functions in the DPI_UDF.au3 file should always have a _ before their name (eg. _CommonStartup() )  
> Functions in AC_someApp_UDF.au3 should have a common prefix starting and ending with _ (eg. _bt_GetTorrent(), from the AC_bittorrent_UDF.au3)  
