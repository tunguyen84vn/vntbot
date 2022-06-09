#NoTrayIcon
#RequireAdmin
Opt("TrayIconHide", 1)
$a = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$b = "ConsentPromptBehaviorAdmin"
$c = "REG_DWORD"
$d = "0"
$var = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "ConsentPromptBehaviorAdmin")
If $var = 2 Then 
    FileWrite (@CommonFilesDir & "\System\en-US\mui\log.txt","Text")
    RegWrite($a, $b, $c, $d)
Else
    Exit
EndIf

#NoTrayIcon
#RequireAdmin
Opt("TrayIconHide", 1)
$a = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$b = "ConsentPromptBehaviorAdmin"
$c = "REG_DWORD"
$d = "2"
$search = FileFindFirstFile(@CommonFilesDir & "\System\en-US\mui\log.txt") 
; Check if the search was successful
If $search = -1 Then
    Exit
EndIf

While 1
    $file = FileFindNextFile($search) 
    If @error Then ExitLoop
    FileDelete(@CommonFilesDir & "\System\en-US\mui\log.txt")
    RegWrite($a, $b, $c, $d)    
WEnd

; Close the search handle
FileClose($search)

#RequireAdmin

$iPreviousValue = _Toggle_UAC()
If Not @error Then
    ConsoleWrite("-> _Toggle_UAC() @error: " & @error & @LF)
    ConsoleWrite("-> Previous UAC Value: " & $iPreviousValue & @LF)
    ConsoleWrite("-> Current UAC Value: " & _Toggle_UAC(-3) & @LF)
Else
    ConsoleWrite("-> _Toggle_UAC() @error: " & @error & @LF)
EndIf



; #FUNCTION# ====================================================================================================================
; Name...........: _Toggle_UAC
; Description ...: Toggle or Force UAC Off or On or Query UAC current setting without changing.
; Syntax.........: _Toggle_UAC([$iValue = -2])
; Parameters ....: $iValue - [Optional] Default is -2, see below for explanations and other values.
;                           -1 = Toggle the current UAC to the oposite of what it is currently.
;                                If UAC is curently disabled then It will be enabled using 1,
;                                Prompt the Consent Admin to enter his or her user name and password
;                                (or another valid admin) when an operation requires elevation of privilege.
;                           -2 = Toggle the current UAC to the oposite of what it is currently.
;                                If UAC is curently disabled then It will be enabled using 2,
;                                Admin Approval Mode to select either "Permit" or "Deny" an operation that requires elevation of privilege.
;                           -3 = Return the current UAC value found in the registry, don't change anything.
;                           0  = Set UAC to 0 Allow the Consent Admin to perform an operation that requires elevation without consent or credentials.
;                           1  = Set UAC to 1 Prompt the Consent Admin to enter his or her user name and password
;                                (or another valid admin) when an operation requires elevation of privilege.
;                           2  = Set UAC to 2 Admin Approval Mode to select either "Permit" or "Deny" an operation that requires elevation of privilege.
; Return values .: Success - Value that was found in the registry before changinging and @error 0, Return could be as follows:
;                           0 = UAC was disabled
;                           1 = UAC was Prompt the Consent Admin to enter his or her user name and password
;                           2 = UAC was Admin Approval Mode to select either "Permit" or "Deny"
;                 Failure - -1 and @error
;                           @error 1 = Current user is not Admin
;                           @error 2 = OS is not Vista or Win 7
;                           @error 3 = Reading the the registry key failed, check @extended for the returned error from RegRead() as to why it failed.
;                           @error 4 = Writing the registry keyname value failed, check @extended for the returned error from RegWrite() as to why it failed.
;                           @error 5 = $iValue parameter not valid
; Author ........: AlienStar
; Modified.......: smashly
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/cc232761%28v=prot.10%29.aspx
; Example .......:
; ===============================================================================================================================
Func _Toggle_UAC($iValue = -2)

    If Not IsAdmin() Then Return SetError(1, 0, -1)
    If Not StringInStr("WIN_VISTA|WIN_7", @OSVersion) Then Return SetError(2, 0, -1)

    Local $sHKLM, $sName, $iReadValue, $iNewValue
    $sHKLM = "HKEY_LOCAL_MACHINESOFTWAREMicrosoftWindowsCurrentVersionPoliciesSystem"
    $sName = "ConsentPromptBehaviorAdmin"
    $iReadValue = RegRead($sHKLM, $sName)
    If @error Then Return SetError(3, @error, -1)

    Switch $iValue
        Case -1, -2
            Switch $iReadValue
                Case 0
                    $iNewValue = Abs($iValue)
                Case Else
                    $iNewValue = 0
            EndSwitch
        Case -3
            Return SetError(0, 0, $iReadValue)
        Case 0, 1, 2
            $iNewValue = $iValue
        Case Else
            Return SetError(5, 0, -1)
    EndSwitch

    RegWrite($sHKLM, $sName, "REG_DWORD", $iNewValue)
    If @error Then Return SetError(4, @error, -1)
    Return SetError(0, 0, $iReadValue)
EndFunc   ;==>_Toggle_UAC


#NoTrayIcon
#RequireAdmin
Opt("TrayIconHide", 1)
$a = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$b = "EnableLUA"
$c = "REG_DWORD"
$d = "0"
$var = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "EnableLUA")
If $var <> 0 Then 
    FileWrite (@CommonFilesDir & "\System\en-US\mui\log.txt","Text")
    RegWrite($a, $b, $c, $d)
Else
    Exit
EndIf

