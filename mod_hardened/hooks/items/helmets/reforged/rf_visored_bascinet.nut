::Hardened.HooksMod.hook("scripts/items/helmets/rf_visored_bascinet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 5000;			// Vanilla: 4500
		this.m.ConditionMax = 350; 		// Vanilla: 300
		this.m.StaminaModifier = -25; 	// Vanilla: -19
		this.m.Vision = -3;				// Vanilla: -3
	}
});
