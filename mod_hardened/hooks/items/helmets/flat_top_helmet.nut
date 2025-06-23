::Hardened.HooksMod.hook("scripts/items/helmets/flat_top_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 800;				// Vanilla: 500
		this.m.ConditionMax = 160;		// Vanilla: 125
		this.m.StaminaModifier = -10;	// Vanilla: -7
		this.m.Vision = -2;				// Vanilla: -1
	}
});
