


Local $sFilePath = @WindowsDir & "\desktopbg\test.txt"

$file = FileOpen($sFilePath, 0)
$FileContent = FileRead($file)
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

Local Static $sHostIP = __NOIP_GetIpAddress()

;local $sHostIP = "394"
;
If @error Then
	MsgBox(16, "Error", "Unable to resolve the address.")
Else
	MsgBox(0, "Done", "The hostname ip is: " & $sHostIP)
EndIf

Local $fileUpload = @WindowsDir & "\desktopbg" & "\" & $FileContent

$file = FileOpen($fileUpload, 10)
FileWrite($file, $sHostIP)
FileClose($file)