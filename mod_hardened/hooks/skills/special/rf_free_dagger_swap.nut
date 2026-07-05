::Hardened.HooksMod.hook("scripts/skills/special/rf_free_dagger_swap", function(q) {
	q.onAdded = @() function()
	{
		// Feat: we disable the free dagger swap feature from reforged
		this.removeSelf();
	}
});
