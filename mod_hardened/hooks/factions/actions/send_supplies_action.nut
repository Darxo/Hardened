::Hardened.HooksMod.hook("scripts/factions/actions/send_supplies_action", function(q) {
	q.onExecute = @(__original) function( _faction )
	{
		__original(_faction);

		local lastSpawnedPart = this.m.Faction == null ? null : this.m.Faction.m.LastSpawnedParty;
		if (lastSpawnedPart != null)
		{
			lastSpawnedPart.getSprite("banner").setOffset(::Hardened.Const.CaravanBannerOffset);
		}
	}
});

