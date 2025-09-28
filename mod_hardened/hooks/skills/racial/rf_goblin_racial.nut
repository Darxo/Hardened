::Hardened.HooksMod.hook("scripts/skills/racial/rf_goblin_racial", function(q) {
	// We remove the Reforged goblin racial as we add our own version and don't reuse their effects
	q.onAdded = @() function()
	{
		this.removeSelf();
	}
});
