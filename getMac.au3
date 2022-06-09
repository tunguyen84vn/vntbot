#include <File.au3>

Global $sIP, $MAs

$Station=InputBox("Workstation", "enter the workstation", "")

_GetMACFromIP($sIP)
Local $text = StringReplace($MAs, "-", "")
IniWrite(@ScriptDir & "\MAC.ini", "mac_addresses", $Station, $text)


Func _GetMACFromIP($sIP)
    Local $MAC,$MACSize
    Local $MAi,$MAr

;Create the struct
$MAC        = DllStructCreate("byte[6]")

;Create a pointer to an int
$MACSize    = DllStructCreate("int")

;*MACSize = 6;
DllStructSetData($MACSize,1,6)

;call inet_addr($sIP)
$MAr = DllCall ("Ws2_32.dll", "int", "inet_addr", _
                "str", $sIP)
$iIP = $MAr[0]

;Make the DllCall
$MAr = DllCall ("iphlpapi.dll", "int", "SendARP", _
                "int", $iIP, _
                "int", 0, _
                "ptr", DllStructGetPtr($MAC), _
                "ptr", DllStructGetPtr($MACSize))

;Format the MAC address into user readble format: 00:00:00:00:00:00
$MAs    = ""
For $MAi = 0 To 5
    If $MAi Then $MAs = $MAs & "-"
        $MAs = $MAs & Hex(DllStructGetData($MAC,1,$MAi+1),2)
Next

;Return the user readble MAC address
    Return $MAs
EndFunc