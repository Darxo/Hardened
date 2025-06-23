::Hardened.HooksMod.hook("scripts/items/helmets/full_leather_cap", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 100;				// Vanilla: 80
		this.m.ConditionMax = 60; 		// Vanilla: 45
		this.m.StaminaModifier = -6; 	// Vanilla: -3
		this.m.Vision = -1;				// Vanilla: 0
	}
});
