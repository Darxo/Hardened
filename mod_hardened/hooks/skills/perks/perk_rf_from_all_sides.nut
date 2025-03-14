::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_from_all_sides", function(q) {
	q.onAdded = @(__original) function()
	{
		__original();

		// In Reforged this perk is granted by flail mastery but it is also serialized by default
		// It will persist on anyone with flail mastery after loading a game
		// Sow we remove it now on player characters only
		if (::MSU.isKindOf(this.getContainer().getActor(), "player"))
		{
			::logWarning("Hardened: Clean up From all Sides");
			this.removeSelf();
		}
	}
});
