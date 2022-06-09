; #INDEX# =======================================================================================================================
; Title .........: Wallpaper Changer v.1.2.0
; AutoIt Version : v3.3.8.1
; Description ...: A little program to dinamically change your wallpapers
; Author(s) .....: Nessie
; ===============================================================================================================================
#include <GDIPlus.au3>

#region Settings
$iWait = 2000 ;Change the background every 50 seconds
$iLoop = -1 ;The number of changing wallpaper loop, set -1 to infinite loop
$sWallpapersPath = @ScriptDir & "\Wallpapers\" ;Remember to put the "\" at the end!
$bOnline = False ;Set to True if you want to download the wallpapers from your website, otherwise set this value to False
$sURL = "http://127.0.0.1/TEST/wallpaper.php" ;The url where the .php script is stored !!WARNING!! You have to put this .php in the same directory where the wallpapers are stored
$bRestoreWallpaper = True ;Set to True if you want to restore the original wallpaper at the script exit, otherwise set this value to False
$iWallStyle = 2 ;Default wallpaper style, for more info see _ChangeWallpaper header
$bAutoResize = True ;Autosize the wallpaper, if it have a higher resolution than screen. (Only for Vista and later!)
#endregion Settings

OnAutoItExitRegister("_Terminate")
HotKeySet(("^!e"), "_Terminate") ;CTRL+ALT+E to terminate the process.

If $bRestoreWallpaper Then
    Global $sTileWallPaper = RegRead("HKEY_CURRENT_USER\Control Panel\Desktop", "TileWallPaper")
    Global $sWallpaperStyle = RegRead("HKEY_CURRENT_USER\Control Panel\Desktop", "WallpaperStyle")
    Global $sOriginalWallpaper = RegRead("HKEY_CURRENT_USER\Control Panel\Desktop", "Wallpaper")
EndIf

If Not FileExists($sWallpapersPath) Then
    MsgBox(16, "Error", "This path: " & $sWallpapersPath & " doesn't exist.")
    Exit
EndIf

If $bOnline Then

    $sSource = BinaryToString(InetRead($sURL, 1))
    If @error Then
        MsgBox(16, "Error", "Unable to download the source of the page.")
        Exit
    EndIf

    $aImageNames = StringRegExp($sSource, "<tr>(.*?)</tr>", 3)
    If @error Then
        MsgBox(16, "Error", "Unable to grab the images name.")
        Exit
    EndIf

    $aRegex = StringRegExp($sURL, "(.+/)", 3) ;Retrive the path where the images are stored, in this example http://127.0.0.1/b/Wallpaper/
    If @error Then
        MsgBox(16, "Error", "Unable to grab the images path.")
        Exit
    EndIf

    $sURL_ImagePath = $aRegex[0]

    For $i = 0 To UBound($aImageNames) - 1
        ;Convert all the image name to .bmp format, to check if the converted images is already store on the user pc
        $sImageName = StringRegExpReplace($aImageNames[$i], "(.*)\..*$", "$1.bmp") ;If image name already .bmp don't touch it, already change extension

        If FileExists($sWallpapersPath & $sImageName) Then ;The .bmp image equivalent already exist, we don't need to re-download the original file images
            ContinueLoop
        EndIf

        Local $hDownload = InetGet($sURL_ImagePath & $aImageNames[$i], $sWallpapersPath & $aImageNames[$i])
        If @error Then ContinueLoop
        InetClose($hDownload)
    Next

EndIf

$search = FileFindFirstFile($sWallpapersPath & "*.*") ;We do that so we can grab all .bmp even if they are not in the website page, so the user can run custom wallpaper too
If $search = -1 Then
    MsgBox(0, "Error", "I can't find any images.")
    Exit
EndIf

$iCount = -1
$iDimension = 10
Local $aWallpapers[$iDimension]

While 1
    Local $file = FileFindNextFile($search)
    If @error Then ExitLoop

    $sFileExt = StringLower(StringRight($file, 4))

    If $sFileExt <> '.bmp' And _GetWinVersion() < 6.0 Then
        $file = _ImageSaveToBMP($sWallpapersPath & $file, $sWallpapersPath, Default, False, True)
        If @error Then ContinueLoop
    Else
        If _GetWinVersion() >= 6.0 And $sFileExt <> '.bmp' And $sFileExt <> '.jpg' Then
            $file = _ImageSaveToBMP($sWallpapersPath & $file, $sWallpapersPath, Default, False, True)
            If @error Then ContinueLoop
        EndIf
    EndIf

    $iCount += 1

    If $iCount > $iDimension - 1 Then
        $iDimension += 10
        ReDim $aWallpapers[$iDimension]
    EndIf

    $aWallpapers[$iCount] = $sWallpapersPath & $file
WEnd
FileClose($search)

ReDim $aWallpapers[$iCount + 1]

$i = 0

While 1 = 1
    If $iLoop > -1 Then
        If $i > $iLoop Then
            ExitLoop
        EndIf
        $i += 1
    EndIf

    For $x = 0 To UBound($aWallpapers) - 1
        _ChangeWallpaper($aWallpapers[$x], $iWallStyle, $bAutoResize)
        If @error Then
            MsgBox(16, "Error", "Unable to change the wallpaper.")
            Exit
        EndIf
        Sleep($iWait)
    Next
WEnd


; #FUNCTION# ====================================================================================================================
; Name...........: _ChangeWallpaper
; Description ...: Change Windows Wallpaper
; Syntax.........: _ChangeWallpaper($sImage, [$iStyle])
; Parameters ....: $sImage   - The path of the .bmp file
;                   $$iStyle  - The numeric value of desidered style
;                              0 Tiled
;                              1 Centered
;                              2 Stretched
;                              3 Fit (Windows 7 and later)
;                              4 Fill (Windows 7 and later)
;                               5 Screen Width
;                   $bResize   - Automatically resize th image if has a higher resolution than screen
; Return values .: On Success - Return the new file name.
;                  On Failure -
;                               @error = 1 The image doesn't exist
;                               @error = 2 The image is not a .bmp file
;                               @error = 3 Invalid style
;                               @error = 4 Style not supported by OS
;                               @error = 5 Unable to change the wallpaper
; Author ........: Nessie
; ===============================================================================================================================

Func _ChangeWallpaper($sImage, $iStyle = 0, $bResize = True)
    If Not FileExists($sImage) Then Return SetError(1, 0, "")

    Local $sImageExt = StringLower(StringRight($sImage, 4))

    Local $fWinVer = _GetWinVersion()

    If $sImageExt <> '.bmp' And $fWinVer < 6.0 Then
        Return SetError(2, 0, "")
    Else
        If $fWinVer >= 6.0 And $sImageExt <> '.bmp' And $sImageExt <> '.jpg' Then
            Return SetError(2, 0, "")
        EndIf
    EndIf

    If $iStyle < 0 Or $iStyle > 5 Then Return SetError(3, 0, "")

    If $fWinVer < 6.0 Then ; More info http://msdn.microsoft.com/en-us/library/windows/desktop/ms724832%28v=vs.85%29.aspx
        If $iStyle > 2 Then Return SetError(4, 0, "")
    EndIf

    Local $sWallpaperKey = "HKEY_CURRENT_USER\Control Panel\Desktop"

    Local $iTileWallPaper, $iWallpaperStyle

    If $bResize And $fWinVer >= 6.0 Then
        $aImageSize = _ImageGetSize($sImage)
        If @error Then Return SetError(5, 0, "")

        If $aImageSize[0] > @DesktopWidth Or $aImageSize[1] > @DesktopHeight Then
            $iStyle = 5 ;Force style n°5
        EndIf
    EndIf

    Switch $iStyle
        Case 0
            $iTileWallPaper = 1
            $iWallpaperStyle = 0
        Case 1
            $iTileWallPaper = 0
            $iWallpaperStyle = 0
        Case 2
            $iTileWallPaper = 0
            $iWallpaperStyle = 2
        Case 3
            $iTileWallPaper = 0
            $iWallpaperStyle = 6
        Case 4
            $iTileWallPaper = 0
            $iWallpaperStyle = 10
        Case 5
            $iTileWallPaper = 0
            $iWallpaperStyle = 4
    EndSwitch

    RegWrite($sWallpaperKey, "TileWallPaper", "REG_SZ", $iTileWallPaper)
    If @error Then Return SetError(5, 0, "")
    RegWrite($sWallpaperKey, "WallpaperStyle", "REG_SZ", $iWallpaperStyle)
    If @error Then Return SetError(5, 0, "")

    ;Thanks to guinness for his advice
    ; Idea from here: http://www.autoitscript.com/forum/topic/19370-autoit-wrappers/page__st__280#entry652536
    ; $SPI_SETDESKWALLPAPER, $SPIF_UPDATEINIFILE and $SPIF_SENDCHANGE can be found on APIConstants.au3 included on WinAPIEx by Yashied
    ;Return _WinAPI_SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, DllStructGetPtr($tBuffer), BitOR($SPIF_UPDATEINIFILE, $SPIF_SENDCHANGE))
    Local $tBuffer = DllStructCreate('wchar Text[' & StringLen($sImage) + 1 & ']')
    DllStructSetData($tBuffer, 'Text', $sImage)
    Return _WinAPI_SystemParametersInfo(0x0014, 0, DllStructGetPtr($tBuffer), BitOR(0x0001, 0x0002))
    If @error Then Return SetError(5, 0, "")

    Return True
EndFunc   ;==>_ChangeWallpaper

; #FUNCTION# ====================================================================================================================
; Name ..........: _ImageSaveToBMP
; Description ...: Convert an image to bmp format
; Syntax ........: _ImageSaveToBMP($sPath[, $sDestPath = @ScriptDir[, $sName = Default[, $bOverwrite = False[, $bDelOrig = False]]]])
; Parameters ....: $sPath               - A string value.
;                  $sDestPath           - The path where to save the converted image. Default is @ScriptDir.
;                  $sName               - The name of the converted image. Default is the original photo name.
;                  $bOverwrite          - Overwrite the converted file if already exist. Default is False.
;                  $bDelOrig            - Delete the original file after conversion. Default is False.
; Return values .: On Success - Return the new file names
;                  On Failure -
;                               @error = 1 The file to be converted doesn't not exist
;                               @error = 2 The image is already a bmp file
;                               @error = 3 Invalid file extension
;                               @error = 4 The destination path doesn't not exist
;                               @error = 5 Invalid file name
;                               @error = 6 The destination file already exist
;                               @error = 7 Unable to overwrite the destination file
;                               @error = 8 Unable to save the bmp file
; Author ........: Nessie
; Example .......: _ImageSaveToBMP(@DesktopDir & "\nessie.jpg")
; ===============================================================================================================================
Func _ImageSaveToBMP($sPath, $sDestPath = @ScriptDir, $sName = Default, $bOverwrite = False, $bDelOrig = False)
    Local $bCheckExt = False

    If Not FileExists($sPath) Then Return SetError(1, 0, "")

    Local $sImageExt = StringLower(StringTrimLeft($sPath, StringInStr($sPath, '.', 0, -1)))

    If $sImageExt = "bmp" Then SetError(2, 0, "")

    Local $aAllowedExt[5] = ['gif', 'jpeg', 'jpg', 'png', 'tiff']

    For $i = 0 To UBound($aAllowedExt) - 1
        If $sImageExt = $aAllowedExt[$i] Then
            $bCheckExt = True
            ExitLoop
        EndIf
    Next

    If $bCheckExt = False Then Return SetError(3, 0, "")

    If Not FileExists($sDestPath) Then Return SetError(4, 0, "")

    If $sName = Default Then
        $sName = StringTrimLeft($sPath, StringInStr($sPath, '\', 0, -1))
        $sName = StringTrimRight($sName, 4)
    Else
        If $sName = "" Then Return SetError(5, 0, "")
    EndIf

    If Not $bOverwrite Then
        If FileExists($sDestPath & "\" & $sName & ".bmp") Then
            Return SetError(6, 0, "")
        EndIf
    Else
        FileDelete($sDestPath & "\" & $sName & ".bmp")
        If @error Then
            Return SetError(7, 0, "")
        EndIf
    EndIf

    _GDIPlus_Startup()

    Local $hImage = _GDIPlus_ImageLoadFromFile($sPath)
    Local $sCLSID = _GDIPlus_EncodersGetCLSID("BMP")

    _GDIPlus_ImageSaveToFileEx($hImage, $sDestPath & "\" & $sName & ".bmp", $sCLSID)

    If @error Then
        _GDIPlus_Shutdown()
        Return SetError(8, 0, "")
    EndIf

    _GDIPlus_Shutdown()

    If $bDelOrig Then
        FileDelete($sPath)
        If @error Then Return SetError(8, 0, "")
    EndIf

    Return $sName & ".bmp"
EndFunc   ;==>_ImageSaveToBMP

; #FUNCTION# ====================================================================================================================
; Name ..........: _ImageGetSize
; Description ...: Retive the size of an image (Width & Height)
; Syntax ........: _ImageGetSize($sImage)
; Parameters ....: $sImage              - The path of the image.
; Return values .: Return an array with the image size
;                  On Success -
;                               $array[0] = Image Width
;                               $array[1] = Image Height
;                  On Failure -
;                               @error = 1 The file doesn't exist
;                               @error = 2 Unable to load the image
;                               @error = 3 Unable to get the image Width
;                               @error = 4 Unable to get the image Height
; Author ........: Nessie
; Example .......: _ImageGetSize("C:\Nessie.jpg")
; ===============================================================================================================================
Func _ImageGetSize($sImage)
    Local $aResult[2]

    If Not FileExists($sImage) Then Return SetError(1, 0, "")

    _GDIPlus_Startup()

    Local $hImage = _GDIPlus_ImageLoadFromFile($sImage)
    If @error Then Return SetError(2, 0, "")

    $iWidth = _GDIPlus_ImageGetWidth($hImage)
    If @error Then Return SetError(3, 0, "")

    $iHeight = _GDIPlus_ImageGetHeight($hImage)
    If @error Then Return SetError(4, 0, "")

    _GDIPlus_ImageDispose($hImage)
    _GDIPlus_Shutdown()

    $aResult[0] = $iWidth
    $aResult[1] = $iHeight

    Return $aResult
EndFunc   ;==>_ImageGetSize

Func _GetWinVersion()
    Local $sRet = RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\', 'CurrentVersion')
    If @error Then Return SetError(0, 0, "")

    Return $sRet
EndFunc   ;==>_GetWinVersion

Func _Terminate()
    If $bRestoreWallpaper Then
        RegWrite("HKEY_CURRENT_USER\Control Panel\Desktop", "TileWallPaper", $sTileWallPaper)
        RegWrite("HKEY_CURRENT_USER\Control Panel\Desktop", "WallpaperStyle", $sWallpaperStyle)
        DllCall("user32.dll", "int", "SystemParametersInfo", "int", 20, "int", 0, "str", $sOriginalWallpaper, "int", BitOR(1, 2))
    EndIf

    Exit
EndFunc   ;==>_Terminate