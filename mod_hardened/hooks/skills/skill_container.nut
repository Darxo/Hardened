::Hardened.HooksMod.hook("scripts/skills/skill_container", function(q) {
	q.collectGarbage = @(__original) function( _performUpdate = true )
	{
		local oldLogDebug = ::logDebug;
		::logDebug = function( _log )
		{
			if (_log.find("Skill [") != null) return;	// We skip these kinds of logs

			oldLogDebug(_log);
		}

		__original(_performUpdate);

		::logDebug = oldLogDebug;
	}
});
