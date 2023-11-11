::Hardened.HooksMod.hook("scripts/skills/special/rf_veteran_levels", function(q) {
	q.onAdded = @() function()
	{
		this.removeSelf();
	}
});
