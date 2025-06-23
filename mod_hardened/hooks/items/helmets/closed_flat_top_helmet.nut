::Hardened.HooksMod.hook("scripts/items/helmets/closed_flat_top_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 1100;			// Vanilla: 1000
		this.m.ConditionMax = 180; 		// Vanilla: 170
		this.m.StaminaModifier = -12; 	// Vanilla: -10
		this.m.Vision = -3;				// Vanilla: -3
	}
});
