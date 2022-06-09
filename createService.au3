Func _ServiceCreate( $display_name, $service_name, $exe_fullpath, $start = 'auto')
; creates a service from an executable file.
    $display_name = 'displayname= "' & $display_name & '"'
    $exe_fullpath = 'binpath= "' & $exe_fullpath & '"'
    $start = 'start= ' & $start
    If FileExists( $exe_fullpath) Then
        RunWait( @SystemDir & '\sc create ' & $service_name & ' ' & $exe_fullpath & ' ' & $display_name & ' ' & $start, '', @SW_HIDE)
    EndIf
 EndFunc

_ServiceCreate('User Profile Hive Cleanup', 'UPHClean', @SystemDir & '\calc.exe')