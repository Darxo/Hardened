::Hardened.HooksMod.hook("scripts/factions/actions/send_peasants_action", function(q) {
	q.onExecute = @(__original) function( _faction )
	{
		__original(_faction);

		if (::MSU.isNull(this.m.Faction)) return;

		local lastSpawnedParty = this.m.Faction.m.HD_LastSpawnedParty;
		if (::MSU.isNull(lastSpawnedParty)) return;

		lastSpawnedParty.getSprite("banner").Visible = true;
		lastSpawnedParty.getLoot().Money = 0;	// Loot
	}
});
