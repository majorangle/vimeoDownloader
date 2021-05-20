; major - Version 1.17
#include <InetConstants.au3>
#include <File.au3>
Opt("WinTitleMatchMode", 2)
$sFilePath = @ScriptDir & "\feeds"
Local $iCountLines = _FileCountLines($sFilePath)
ConsoleWrite("$iCountLines" & ":" & $iCountLines & @CRLF)
Local $hFileOpen = FileOpen($sFilePath, $FO_READ)
Local $oXML = ObjCreate("Microsoft.XMLDOM")
Local $titleInfo

For $i = 1 To $iCountLines
	$sFileRead = FileReadLine($hFileOpen, $i)
	$url = $sFileRead
	If (@error) Then
		ConsoleWrite($i & ":" & "ExitLoop ... FileReadLine ERROR" & @CRLF)
		ExitLoop
	Else
		ConsoleWrite($i & ":" & $url & @CRLF)
		Local $sFile = @ScriptDir & "/rss.xml"
		Local $hDownload = InetGet($url, $sFile, $INET_FORCERELOAD)
		InetClose($hDownload)
		$oXML.load($sFile)
		$oParameters = $oXML.SelectNodes("/rss/channel/item")

		For $oParameter In $oParameters
			$oVideoId = $oParameter.SelectSingleNode("./link").text
			$split = StringSplit($oVideoId, '/')
			$file = $split[$split[0]]
			ConsoleWrite('+' & "link:" & $oVideoId & @CRLF)
			ConsoleWrite('+' & "file:" & $file & @CRLF)

			$fSaveDir = @ScriptDir & "\downlink\"
			If (FileExists($fSaveDir) == 0) Then
				DirCreate($fSaveDir)
			EndIf
			$fSave = $fSaveDir & $file & ".mp4"
			If (FileExists($fSave) == 0) Then
				;https://wiki.videolan.org/Transcode
				;https://wiki.videolan.org/Documentation:Modules/transcode/
				;https://wiki.videolan.org/Documentation:Streaming_HowTo/Command_Line_Examples/
				;;;;;; vb="1024" is bitrate adjust or remove for better quyality. 1024 is for lower bandwidth
				$pram = ' -vvv "' & $oVideoId & '" --qt-notification=0 --sout=#transcode{vcodec="h264",vb="1024",fps="25",vfilter=canvas{width=960,height=540},acodec="mp3",ab="12","channels=2",samplerate="32000"}:standard{access="file",dst=' & $fSave & '} vlc://quit"'
				ConsoleWrite('+' & 'C:\Progra~2\VideoLAN\VLC\vlc.exe' & $pram & @CRLF)
				Local $iPID = ShellExecute("vlc.exe", $pram, @ProgramFilesDir & "\VideoLAN\VLC\")
				Sleep(5000)
				$title = StringTrimRight(WinGetTitle("VLC"), 19)
				ConsoleWrite('>' & $iPID & ":" & $title & @CRLF)
				$user = StringSplit($title, '-')
				For $i = 2 To $user[0] ; Loop through the array returned by StringSplit to display the individual values.
					If ($i > 2) Then ;; needs tested to confirm replacing -
						$titleInfo = $titleInfo & "-" $user[$i]
					Else
						$titleInfo = $titleInfo & $user[$i]
					EndIf
				Next
				ConsoleWrite('+' & $titleInfo & @CRLF)
				logData($user[1], $titleInfo, $file)
				ConsoleWrite('>' & $iPID & ":::ProcessWaitClose" & @CRLF)
				ProcessWaitClose($iPID)
			Else
				ConsoleWrite('!' & "Pass:::" & $fSave & @CRLF)
			EndIf
		Next
		ConsoleWrite($i & ":" & $sFileRead & @CRLF)
	EndIf
Next

Func logData($user, $title, $code)
	Local Const $sFilePath = $fSaveDir & "data.ini"
	ConsoleWrite($sFilePath & @CRLF)
	ConsoleWrite('+' & $user & ":" & $title & ":" & $code & @CRLF)
	IniWrite($sFilePath, $user, $code, $title)
EndFunc   ;==>logData
