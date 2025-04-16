::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_steady_brace", function(q) {
	// While steady brace is not yet balanced, I will disable it on enemies
	q.onSpawned = @(__original) function()
	{
		__original();
		if (this.getContainer().getActor().getFaction() != ::Const.Faction.Player)
		{
			this.removeSelf();
		}
	}
});
