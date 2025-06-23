::Hardened.HooksMod.hook("scripts/items/helmets/padded_flat_top_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 800;				// Vanilla: 800
		this.m.ConditionMax = 160; 		// Vanilla: 150
		this.m.StaminaModifier = -10; 	// Vanilla: -9
		this.m.Vision = -2;				// Vanilla: -1
	}
});
