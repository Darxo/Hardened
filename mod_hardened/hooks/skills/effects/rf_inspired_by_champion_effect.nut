::Hardened.HooksMod.hook("scripts/skills/effects/rf_inspired_by_champion_effect", function(q) {
	// Feat: this effect no longer appears
	q.onAdded = @() function()
	{
		this.removeSelf();
	}
});
