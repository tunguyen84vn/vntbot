#include <InetConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>
#include <Date.au3>

#NoTrayIcon
#RequireAdmin

global static $install 
global static $inject 
global static $crack 



Crack()
Func Crack()
Run(@ComSpec & " /C " & "sc start servermanager","",@SW_HIDE)
;Run(@ComSpec & ' /C @sqlite3 ..\BarServer\data\barserver.db "DELETE FROM tbl_BarServerPacket;"',"",@SW_HIDE)
;Run(@ComSpec & ' /C @sqlite3 -header -csv ..\BarServer\data\barserver.db ".import key.csv tbl_BarServerPacket"',"",@SW_HIDE)
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

