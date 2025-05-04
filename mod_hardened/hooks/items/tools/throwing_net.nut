::Hardened.HooksMod.hook("scripts/items/tools/throwing_net", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.StaminaModifier = -4; // In Vanilla this is -2
	}
});
