::Hardened.HooksMod.hook("scripts/factions/actions/defend_military_action", function(q) {
	q.onExecute = @(__original) function( _faction )
	{
		local spawnLocations = [];
		foreach (a in this.m.Settlement.getAttachedLocations())
		{
			if (a.isActive() && a.isMilitary())
			{
				spawnLocations.push(a);
			}
		}

		// We mock faction.spawnEntity in order to trigger setLastSpawnTimeToNow on any attached location, which was picked for spawning
		// That way those locations, if they can spawn defender, will reroll their line-up and be a bit weaker
		local mockObject = ::Hardened.mockFunction(_faction, "spawnEntity", function(...) {
			if (vargv.len() == 5)
			{
				foreach (attachedLocation in spawnLocations)
				{
					if (attachedLocation.getTile().isSameTileAs(vargv[0]))
					{
						attachedLocation.setLastSpawnTimeToNow();
					}
				}
			}
		});

		local ret = __original(_faction);

		mockObject.cleanup();

		return ret;
	}
});

