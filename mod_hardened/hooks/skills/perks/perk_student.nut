::Hardened.HooksMod.hook("scripts/skills/perks/perk_student", function(q) {
	// Public
	q.m.RefundLevel <- 8;	// The perk point spend, is refunded when reaching this level

	// Private
	q.m.VanillaPayoutLevel <- 11;	// Vanilla hands out its student payout (+1 perk) at this level

	q.onUpdate = @() function( _properties ) {}	// Overwrite. This perk no longer grants experience

	// If a character learns this perk at a later point, they still gain the perk point
	q.onAdded = @(__original) function()
	{
		__original();
		local actor = this.getContainer().getActor();
		if (this.m.IsNew && actor.getLevel() >= this.m.RefundLevel && actor.getLevel() < this.m.VanillaPayoutLevel)
		{
			actor.m.PerkPoints += 1;
		}
	}

	q.onUpdateLevel = @() function()
	{
		local actor = this.getContainer().getActor();
		if (actor.getLevel() == this.m.RefundLevel)
		{
			actor.m.PerkPoints += 1;
		}

		// Revert the vanilla student effect
		if (actor.m.Level == this.m.VanillaPayoutLevel)
		{
			actor.m.PerkPoints -= 1;
		}
	}
});
