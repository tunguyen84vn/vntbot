;By placing the compiled exe version of this in your startup folder,
;your desktop background automatically gets synchronized with the BING homepage's background image
;
;Here we include the libraries required
#include <IE.au3>
#include <INet.au3>
#include <String.au3>
;
;The following code snippet gets the source code of specified page in text format to the variable
;$sSource
Global $sSource = _INetGetSource("http://www.bing.com")
;The image url lies in between the strings 'g_img={url:' and ','
;you can check this by opening the source code of page in your browser
Global $aImgURL = _StringBetween($sSource, 'g_img={url:', ',')
;Creating a directory to store the images
;You can always change the below directory to where ever you wish to store
If Not FileExists("D:\desktopbg") Then DirCreate("D:\desktopbg")
;clearing the ''s to get the exact url
;to see what comes to $aImgURL[0] uncomment the next line and run it
;MsgBox(0,"",$aImgURL[0])
Global $stext = StringReplace($aImgURL[0], "'", "")
;
$stext1 =  StringReplace($stext,"/","\")
$sURL = "http://www.bing.com" & $stext
;spitting the url based on \ and getting the image name
$st1 = StringSplit($stext1,"\")
;$nn = size of array $st1
$nn = UBound($st1)
$kk = $st1[$nn-1]
;MsgBox(0,"",$kk)
;Destination image
Global $nFile="d:\desktopbg\" & $kk
;MsgBox(0,"",$nFile)
;Exit if no update
If FileExists($nFile) Then Exit
;Download the image
InetGet($sURL,$nFile)
;
;Set it as your desktop background
Global $SPI_SETDESKWALLPAPER = 20
Global $SPIF_UPDATEINIFILE = 1
Global $SPIF_SENDCHANGE = 2
Global $REG_DESKTOP= "HKEY_CURRENT_USER\Control Panel\Desktop"
RegWrite("HKEY_CURRENT_USER\Control Panel\Desktop", "TileWallPaper", "REG_SZ", 0)
RegWrite("HKEY_CURRENT_USER\Control Panel\Desktop", "WallpaperStyle", "REG_SZ", 0)
RegWrite("HKEY_CURRENT_USER\Control Panel\Desktop", "Wallpaper", "REG_SZ", $nFile)
DllCall("user32.dll", "int", "SystemParametersInfo", _
"int", $SPI_SETDESKWALLPAPER, _
"int", 0, _
"str", $nFile, _
"int", BitOR($SPIF_UPDATEINIFILE, $SPIF_SENDCHANGE))
;
Exit