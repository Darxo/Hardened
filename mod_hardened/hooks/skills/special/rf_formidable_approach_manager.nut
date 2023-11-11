::Hardened.HooksMod.hook("scripts/skills/special/rf_formidable_approach_manager", function(q) {
	q.onAdded = @() function()
	{
		this.removeSelf();
	}
});
