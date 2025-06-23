::Hardened.HooksMod.hook("scripts/items/helmets/rf_half_closed_sallet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 3000;			// Vanilla: 2400
		this.m.ConditionMax = 200; 		// Vanilla: 200
		this.m.StaminaModifier = -10; 	// Vanilla: -10
		this.m.Vision = -3;				// Vanilla: -2
	}
});
