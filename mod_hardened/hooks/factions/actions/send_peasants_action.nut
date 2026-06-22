::Hardened.HooksMod.hook("scripts/factions/actions/send_peasants_action", function(q) {
	q.onExecute = @(__original) function( _faction )
	{
		__original(_faction);

		if (::MSU.isNull(this.m.Faction)) return;

		local lastSpawnedParty = this.m.Faction.m.HD_LastSpawnedParty;
		if (::MSU.isNull(lastSpawnedParty)) return;

		lastSpawnedParty.getSprite("banner").Visible = true;
		lastSpawnedParty.getLoot().Money = 0;	// Loot
		lastSpawnedParty.setVisionRadius(lastSpawnedParty.m.VisionRadius * 0.8);		// Peasants have 20% less Vision
	}
});
