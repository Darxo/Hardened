::Hardened.HooksMod.hook("scripts/items/helmets/adorned_full_helm", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 3500;			// Vanilla: 3700
		this.m.ConditionMax = 300; 		// Vanilla: 300
		this.m.StaminaModifier = -20; 	// Vanilla: -18
		this.m.Vision = -3;				// Vanilla: -3
	}
});
