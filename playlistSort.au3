#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <File.au3>
#include <Array.au3>
Local Const $sFilePath = 'E:\downlink\' & "playlist.xspf"
Local Const $sFilePath_sort = 'E:\downlink\' & "playlist_sorted.xspf"
Local $hFileOpen = FileOpen($sFilePath, $FO_READ)
Local $oXML = ObjCreate("Microsoft.XMLDOM")
Local $data[0][4], $sString

$oXML.load($sFilePath)
$oParameters = $oXML.SelectNodes("//playlist/trackList/track")
For $oParameter In $oParameters
	Local $sFill = String($oParameter.SelectSingleNode("./date").text) & '|' & _
			String($oParameter.SelectSingleNode("./location").text) & '|' & _
			String($oParameter.SelectSingleNode("./creator").text) & '|' & _
			String($oParameter.SelectSingleNode("./title").text)
	ConsoleWrite('!' & $sFill & @CRLF)
	_ArrayAdd($data, $sFill)
Next

_ArraySort($data, 1)
_ArrayDisplay($data, "AFTER QuickSort descending")
;~ $data1 = _ArraySort($data, 0, 3, 6)

FileDelete($sFilePath_sort)
If Not FileWrite($sFilePath_sort, '<?xml version="1.0"?>' & @CRLF) Then
	ConsoleWrite("An error occurred whilst writing the temporary file.")
EndIf
; Open the file for writing (append to the end of a file) and store the handle to a variable.
Local $hFileOpen = FileOpen($sFilePath_sort, $FO_APPEND)
If $hFileOpen = -1 Then
	ConsoleWrite("An error occurred whilst writing the temporary file.")
EndIf
If @error = 1 Then
	MsgBox($MB_SYSTEMMODAL, "", "Path was invalid.")
	Exit
EndIf
If @error = 4 Then
	MsgBox($MB_SYSTEMMODAL, "", "No file(s) were found.")
	Exit
EndIf
FileWriteLine($hFileOpen, '<playlist>')
FileWriteLine($hFileOpen, '<trackList>')
FileWriteLine($hFileOpen, @CRLF)

For $i = 0 To UBound($data, 1) - 1
	FileWriteLine($hFileOpen, '<track>')
	FileWriteLine($hFileOpen, '<date>' & $data[$i][0] & '</date>')
	FileWriteLine($hFileOpen, '<location>' & $data[$i][1] & '</location>')
	FileWriteLine($hFileOpen, '<creator>' & $data[$i][2] & '</creator>')
	FileWriteLine($hFileOpen, '<title>' & $data[$i][3] & '</title>')
	FileWriteLine($hFileOpen, '</track>')
	FileWriteLine($hFileOpen, @CRLF)
Next

FileWriteLine($hFileOpen, @CRLF)
FileWriteLine($hFileOpen, '</trackList>')
FileWriteLine($hFileOpen, '</playlist>')
FileClose($hFileOpen)

