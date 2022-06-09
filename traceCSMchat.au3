#include <InetConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>
#include <Date.au3>

#NoTrayIcon
#RequireAdmin

While True
    $win = WinWait("ABCD", "Defer")
    ControlClick($win, "", "[CLASS:Button; INSTANCE:2]")
    WinWaitClose($win)

local $sPD = ''
	
	; Creating the object
$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
$oHTTP.Open("POST", "http://vitinhvnt.vn/test/setup.php", False)
$oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")

; Performing the Request
$oHTTP.Send($sPD)
Wend
