::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_phalanx", function(q) {
	// Overwrite of Reforged: Buckler no longer set the count to 0 or are ignored when counting.
	q.getCount = @() function()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap()) return 0;
		if (!actor.isArmedWithShield()) return 0;

		local count = 0;
		foreach (ally in ::Tactical.Entities.getAlliedActors(actor.getFaction(), actor.getTile(), 1))
		{
			if (ally.isArmedWithShield() && ally.getID() != actor.getID())
			{
				count += 1;
			}
		}
		return count;
	}
});
