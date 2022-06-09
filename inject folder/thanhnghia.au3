#Include <WinAPIEx.au3>

Local $exeLocation = "G:\Online Games\sys.exe"

Run($exeLocation)

_WinAPI_ShellOpenFolderAndSelectItems('G:\Online Games\30 PopCap Games')