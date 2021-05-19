;;; Testing RSS Data
;; get RSS feed data from sites to create download
#include <InetConstants.au3>
#include <WinAPIFiles.au3>
Local $oXML = ObjCreate("Microsoft.XMLDOM")
Local $url = "https://vimeo.com/gopro/videos/rss"
Local $sFile = @ScriptDir &"/rss.xml"
Local $hDownload = InetGet($url, $sFile, $INET_FORCERELOAD)
InetClose($hDownload)
$oXML.load($sFile)

$oParameters = $oXML.SelectNodes("/rss/channel/item")
For $oParameter In $oParameters
;~         ConsoleWrite($oParameter.SelectSingleNode("./link").text		& @CRLF)
		$link = $oParameter.SelectSingleNode("./link").text
		$split = StringSplit($link,'/')
		$file = $split[$split[0]]
        ConsoleWrite("link:"&$link	& @CRLF)
        ConsoleWrite("file:"&$file	& @CRLF)
;~         $oVideoId = $oParameter.SelectSingleNode("./item/media:content/media:player")
;~         $oTitle = $oParameter.SelectSingleNode("./item/url")
;~		   $oAuthor = $oParameter.SelectSingleNode("./item/media:credit")
;~         ConsoleWrite(String($oAuthor.text) & @CRLF)
;~         ConsoleWrite(String($oVideoId.text) & @CRLF)
;~         ConsoleWrite(String($oTitle.text) & @CRLF)
Next