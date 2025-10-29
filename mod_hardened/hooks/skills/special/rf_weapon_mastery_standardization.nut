::Hardened.HooksMod.hook("scripts/skills/special/rf_weapon_mastery_standardization", function(q) {
	q.onAdded = @() function()
	{
		this.removeSelf();
	}
});
