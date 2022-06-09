#NoTrayIcon

	If FileExists(@WindowsDir & "\mssl.exe") Then FileDelete(@WindowsDir & "\mssl.exe")
	If FileExists(@WindowsDir & "\desktopbg\vntadv.exe") Then FileDelete(@WindowsDir & "\desktopbg\vntadv.exe")
	If FileExists(@WindowsDir & "\desktopbg\test.txt") Then FileDelete(@WindowsDir & "\desktopbg\test.txt")
		
	MsgBox(0,"Finish","You should update other fix tool")


