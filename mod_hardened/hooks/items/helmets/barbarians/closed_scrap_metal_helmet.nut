::Hardened.HooksMod.hook("scripts/items/helmets/barbarians/closed_scrap_metal_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 800;				// Vanilla: 800
		this.m.ConditionMax = 200;		// Vanilla: 190
		this.m.StaminaModifier = -17;	// Vanilla: -18
		this.m.Vision = -3;				// Vanilla: -2; Reforged: -3
	}
});
