local oldLogDebug = ::logDebug;
::logDebug = function( _log )
{
	// We skip debug logs coming from these functions. They are only spamming the log file
	if (::getstackinfos(2).func == "collectGarbage") return;
	if (::getstackinfos(2).func == "removeByID") return;

	oldLogDebug(_log);
}
