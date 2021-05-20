; major - Version 1.17
#include <InetConstants.au3>
#include <File.au3>
Opt("WinTitleMatchMode", 2)
$sFilePath = @ScriptDir & "\feeds"
Local $iCountLines = _FileCountLines($sFilePath)
ConsoleWrite("$iCountLines" & ":" & $iCountLines & @CRLF)
Local $hFileOpen = FileOpen($sFilePath, $FO_READ)
Local $titleInfo
Local $url = 'https://vimeo.com/508927445'

; Split the URL down
$split = StringSplit($url, '/')
;read end of array fir file name
$file = $split[$split[0]]
;write to console for debuging if failures
ConsoleWrite('+' & "link:" & $url & @CRLF)
ConsoleWrite('+' & "file:" & $file & @CRLF)
;define save folder
$fSaveDir = @ScriptDir & "\downlink\"
If (FileExists($fSaveDir) == 0) Then
	;create folder if isnt there.
	DirCreate($fSaveDir)
EndIf
;define save path
$fSave = $fSaveDir & $file & ".mp4"
If (FileExists($fSave) == 0) Then
	;https://wiki.videolan.org/Transcode
	;https://wiki.videolan.org/Documentation:Modules/transcode/
	;https://wiki.videolan.org/Documentation:Streaming_HowTo/Command_Line_Examples/
	;;;;;; vb="1024" is bitrate adjust or remove for better quyality. 1024 is for lower bandwidth
	$pram = ' -vvv "' & $url & '" --qt-notification=0 --sout=#transcode{vcodec="h264",vb="1024",fps="25",vfilter=canvas{width=960,height=540},acodec="mp3",ab="12","channels=2",samplerate="32000"}:standard{access="file",dst=' & $fSave & '} vlc://quit"'
	ConsoleWrite('+' & 'C:\Progra~2\VideoLAN\VLC\vlc.exe' & $pram & @CRLF)
	;Loads COMMAND for VLC
	Local $iPID = ShellExecute("vlc.exe", $pram, @ProgramFilesDir & "\VideoLAN\VLC\")
	;Pause for loading title
	Sleep(5000)
	;extracting VLC window title and remove VLC info
	$title = StringTrimRight(WinGetTitle("VLC"), 19)
	;debug ack $iPID
	ConsoleWrite('>' & $iPID & ":" & $title & @CRLF)

	;Typically - splits authors name from title....  in this case its |
	$user = StringSplit($title, '|')
	; for cycle is a error correction for multiple '|' or '-' as defined
	For $i = 2 To $user[0]             ; Loop through the array returned by StringSplit to display the individual values.
		If ($i > 2) Then             ;; needs tested to confirm replacing -
			$titleInfo = $titleInfo & "-" & $user[$i]
		Else
			$titleInfo = $titleInfo & $user[$i]
		EndIf
	Next
	; debug to console to make sure its all the correct info
	ConsoleWrite('+' & $titleInfo & @CRLF)
	logData($user[1], $titleInfo, $file)
	ConsoleWrite('>' & $iPID & ":::ProcessWaitClose" & @CRLF)
	ProcessWaitClose($iPID)
EndIf

; log data function
Func logData($user, $title, $code)
	Local Const $sFilePath = $fSaveDir & "data.ini"
	ConsoleWrite($sFilePath & @CRLF)
	ConsoleWrite('+' & $user & ":" & $title & ":" & $code & @CRLF)
	IniWrite($sFilePath, $user, $code, $title)
EndFunc   ;==>logData
