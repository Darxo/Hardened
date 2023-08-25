::mods_hookNewObject("skills/skill_container", function(o) {
	local oldCollectGarbage = o.collectGarbage;
	o.collectGarbage = function( _performUpdate = true )
	{
		local oldLogDebug = ::logDebug;
		::logDebug = function( _log )
		{
			if (_log.find("Skill [") != null) return;	// We skip these kinds of logs

			oldLogDebug(_log);
		}

		oldCollectGarbage(_performUpdate);

		::logDebug = oldLogDebug;
	}
});
