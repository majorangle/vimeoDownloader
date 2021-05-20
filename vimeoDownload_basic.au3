; major - Version 1.17
#include <File.au3>
$sFilePath = @ScriptDir & "\feeds"
Local $hFileOpen = FileOpen($sFilePath, $FO_READ)
Local $url = 'https://vimeo.com/508927445'
$split = StringSplit($url, '/')
$file = $split[$split[0]]
$fSave = @ScriptDir & '\'& $file & ".mp4"
If (FileExists($fSave) == 0) Then
	;https://wiki.videolan.org/Documentation:Streaming_HowTo/Command_Line_Examples/
	$pram = ' -vvv "' & $url & '" --qt-notification=0 --sout=#transcode{vcodec="h264",vb="1024",fps="25",vfilter=canvas{width=960,height=540},acodec="mp3",ab="12","channels=2",samplerate="32000"}:standard{access="file",dst=' & $fSave & '} vlc://quit"'
	ConsoleWrite('+' & 'C:\Progra~2\VideoLAN\VLC\vlc.exe' & $pram & @CRLF)
	Local $iPID = ShellExecute("vlc.exe", $pram, @ProgramFilesDir & "\VideoLAN\VLC\")
	ConsoleWrite('>' & $iPID & ":::ProcessWaitClose" & @CRLF)
	ProcessWaitClose($iPID)
EndIf