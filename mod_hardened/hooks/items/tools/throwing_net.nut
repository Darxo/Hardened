::Hardened.HooksMod.hook("scripts/items/tools/throwing_net", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.RangeMax = 3; // Vanilla: 3; Reforged: 2
		this.m.StaminaModifier = -4; // In Vanilla this is -2
	}
});
