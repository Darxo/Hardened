local oldLogDebug = ::logDebug;
::logDebug = function( _log )
{
	// We skip debug logs coming from these functions. They are only spamming the log file
	if (::Hardened.getFunctionCaller() == "collectGarbage") return;
	if (::Hardened.getFunctionCaller() == "removeByID") return;

	oldLogDebug(_log);
}
