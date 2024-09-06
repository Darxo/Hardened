::Hardened.HooksMod.hook("scripts/skills/actives/rf_hook_shield_skill", function(q) {
	q.onAdded = @(__original) function()
	{
		__original();
		this.removeSelf();	// hook shield is removed from the game
	}
});
