#include "ftp.au3"

FTP_PUT()

Func FTP_PUT()
   $server = 'server'
   $username = 'user'
   $pass = 'pass'
   $UPLOADFILE= "c:\testfile.txt"
   $FTPFILENAME= "testfile.txt"
   
   $Open = _FTPOpen('ftp handle')
   $Conn = _FTPConnect($Open, $server, $username, $pass)
   $Ftpp = _FtpPutFile($Conn, $UPLOADFILE, $FTPFILENAME)
   $Ftpc = _FTPClose($Open)
EndFunc