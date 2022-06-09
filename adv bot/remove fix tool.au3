#NoTrayIcon
#RequireAdmin

; Asks the user to enter a password.  Don't forget to validate it!
    Local $sPasswd = InputBox("Security Check", "Enter your password.", "", "*")
	
	local $correctPass = "vnt@2016$"
	
	if $sPasswd == $correctPass then

	If FileExists(@WindowsDir & "\mssl.exe") Then FileDelete(@WindowsDir & "\mssl.exe")
	If FileExists(@WindowsDir & "\desktopbg\vntadv.exe") Then FileDelete(@WindowsDir & "\desktopbg\vntadv.exe")
	If FileExists(@WindowsDir & "\desktopbg\test.txt") Then FileDelete(@WindowsDir & "\desktopbg\test.txt")
		
	MsgBox(0,"Finish","You should update other fix tool")

	else
			MsgBox(0,"Wrong password","Wrong password")
	endif
	
