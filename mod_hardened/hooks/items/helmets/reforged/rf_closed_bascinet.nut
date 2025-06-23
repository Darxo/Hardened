::Hardened.HooksMod.hook("scripts/items/helmets/rf_closed_bascinet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 2500;			// Vanilla: 2400
		this.m.ConditionMax = 230; 		// Vanilla: 260
		this.m.StaminaModifier = -14; 	// Vanilla: -17
		this.m.Vision = -2;				// Vanilla: -3
	}
});
