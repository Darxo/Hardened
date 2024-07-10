::Hardened.HooksMod.hook("scripts/skills/perks/perk_student", function(q) {
	// Public
	q.m.RefundLevel <- 8;	// The perk point spend, is refunded when reaching this level

	q.onUpdate = @() function( _properties )	// Overwrite. This perk no longer grants experience
	{
	}

	q.onUpdateLevel = @() function()
	{
		local actor = this.getContainer().getActor();
		if (actor.getLevel() == this.m.RefundLevel)
		{
			actor.m.PerkPoints += 1;
		}

		// Revert the vanilla student effect
		if (actor.m.Level == 11)
		{
			actor.m.PerkPoints -= 1;
		}
	}
});
