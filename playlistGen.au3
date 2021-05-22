#include <File.au3>
$dir = @ScriptDir
Local Const $sFilePath = $dir & '\playlist.m3u'
Local $sString
FileDelete($sFilePath)

If Not FileWrite($sFilePath, "#EXTM3U" & @CRLF) Then
	ConsoleWrite("An error occurred whilst writing the temporary file.")
EndIf
; Open the file for writing (append to the end of a file) and store the handle to a variable.
Local $hFileOpen = FileOpen($sFilePath, $FO_APPEND)
If $hFileOpen = -1 Then
	ConsoleWrite("An error occurred whilst writing the temporary file.")
EndIf
; List all the files and folders in the desktop directory using the default parameters and return the full path.
Local $aFileList = _FileListToArray($dir, Default, $FLTA_FOLDERS, True)
If @error = 1 Then
	MsgBox($MB_SYSTEMMODAL, "", "Path was invalid.")
	Exit
EndIf
If @error = 4 Then
	MsgBox($MB_SYSTEMMODAL, "", "No file(s) were found.")
	Exit
EndIf
For $vElement In $aFileList
	$sString = $sString & $vElement & @CRLF
	ConsoleWrite($vElement & @CRLF)
	; Assign a Local variable the search handle of all files in the current directory.
	Local $hSearch = FileFindFirstFile($vElement & '\*.mp4')
	; Check if the search was successful, if not display a message and return False.
	If $hSearch = -1 Then
		ConsoleWrite("Error: No files/directories matched the search pattern." & @CRLF)
	EndIf
	; Assign a Local variable the empty string which will contain the files names found.
	Local $sFileName = ""
	While 1
		$sFileName = FileFindNextFile($hSearch)
		; If there is no more file matching the search.
		If @error Then ExitLoop
		ConsoleWrite($sFileName & @CRLF)
		; Display the file name.
		$title = IniRead($vElement & '\data.ini', StringTrimRight($sFileName, 4), 'title', Null)
		FileWriteLine($hFileOpen, $vElement & '\' & $sFileName)
	WEnd
	; Close the search handle.
	FileClose($hSearch)
Next
FileClose($hFileOpen)
