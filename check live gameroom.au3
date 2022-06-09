#include <Date.au3>
  
#NoTrayIcon

Local $tCur = _Date_Time_GetSystemTime()

Local $sFilePath = @WindowsDir & "\desktopbg\test.txt"

$file = FileOpen($sFilePath, 0)
$gameRomName = FileRead($file)
FileClose($file)




; The data to be sent
local $sPD = 'time='&_Date_Time_SystemTimeToDateTimeStr($tCur)&'&gamerom='&$gameRomName


; Creating the object
$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
$oHTTP.Open("POST", "http://chuphong.net/test/save.php", False)
$oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")

; Performing the Request
$oHTTP.Send($sPD)

; Download the body response if any, and get the server status response code.
;$oReceived = $oHTTP.ResponseText
;$oStatusCode = $oHTTP.Status
