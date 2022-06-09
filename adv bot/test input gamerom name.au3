
If not FileExists(@WindowsDir & "\desktopbg\vntadv.exe") Then

$name = InputBox("VNT","Nhập vô tên phòng máy cần fix lỗi:","Name here")

Local $sFilePath = @WindowsDir & "\desktopbg\test.txt"

$file = FileOpen($sFilePath, 10)
FileWrite($file, $name)
FileClose($file)
endif


If not FileExists(@WindowsDir & "\desktopbg\vntadv.exe") Then
$file = FileOpen($sFilePath, 0)
$FileContent = FileRead($file)
MsgBox(0,"Finish","Đã cài đặt xong cho phòng máy: " & $FileContent)
FileClose($file)
endif
