::Hardened.HooksMod.hook("scripts/factions/actions/send_peasants_action", function(q) {
	q.onExecute = @(__original) function( _faction )
	{
		__original(_faction);

		local lastSpawnedParty = this.m.Faction == null ? null : this.m.Faction.m.LastSpawnedParty;
		if (!::MSU.isNull(lastSpawnedParty))
		{
			lastSpawnedParty.getSprite("banner").Visible = true;
			lastSpawnedParty.getLoot().Money = 0;	// Loot
		}
	}
});
