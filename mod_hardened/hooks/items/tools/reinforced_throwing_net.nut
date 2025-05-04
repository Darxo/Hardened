::Hardened.HooksMod.hook("scripts/items/tools/reinforced_throwing_net", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.StaminaModifier = -8; // In Vanilla this is -2
	}
});
