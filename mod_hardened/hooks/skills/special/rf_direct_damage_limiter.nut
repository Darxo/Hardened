::Hardened.HooksMod.hook("scripts/skills/special/rf_direct_damage_limiter", function(q) {
	q.onAdded = @() function()
	{
		this.removeSelf();
	}
});
