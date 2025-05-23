::Hardened.HooksMod.hook("scripts/items/weapons/throwing_spear", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "Lighter than a common spear, but heavier than a javelin, this weapon is intended to be thrown over short distances. The tip will bend on impact, potentially rendering shields unusable. Can be used against unshielded opponents as well for great effect.";
		this.m.Value = 60;	// In Vanilla this is 80
		this.m.StaminaModifier = -4;	// In Vanilla this is -6
	}
});
