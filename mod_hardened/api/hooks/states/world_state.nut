::Hardened.HooksMod.hook("scripts/states/world_state", function(q) {
	q.showCombatDialog = @(__original) function(_isPlayerInitiated = true, _isCombatantsVisible = true, _allowFormationPicking = true, _properties = null, _pos = null)
	{
		if (::World.Assets.m.IsAlwaysShowingScoutingReport)
		{
			local mockObject = ::Hardened.mockFunction(::World.Assets.getOrigin(), "getID", function() {
				if (::Hardened.getFunctionCaller(1) == "showCombatDialog")	// 1 as argument because within mockFunctions, there is an additional function inbetween us and our caller
				{
					return { done = true, value = "scenario.rangers" };
				}
			});

			__original(_isPlayerInitiated, _isCombatantsVisible, _allowFormationPicking, _properties, _pos);
			mockObject.cleanup();
		}
		else
		{
			__original(_isPlayerInitiated, _isCombatantsVisible, _allowFormationPicking, _properties, _pos);
		}
	}

	q.getLocalCombatProperties = @(__original) { function getLocalCombatProperties( _pos, _ignoreNoEnemies = false )
	{
		local combatInfo = __original(_pos, _ignoreNoEnemies);

		combatInfo.HD_IsFightingAtLocation = combatInfo.IsAttackingLocation;

		foreach (party in combatInfo.Parties)
		{
			if (party.isLocation())
			{
				party.HD_onGetLocalCombatProperties(combatInfo);

				if (!party.isAlliedWithPlayer())
				{
					combatInfo.HD_IsAttackingLocation = true;
					break;
				}
			}
		}

		return combatInfo;
	}}.getLocalCombatProperties;
});
