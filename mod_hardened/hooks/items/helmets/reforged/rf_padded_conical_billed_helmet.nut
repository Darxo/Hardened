::Hardened.HooksMod.hook("scripts/items/helmets/rf_padded_conical_billed_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 2000;			// Vanilla: 2900
		this.m.ConditionMax = 140; 		// Vanilla: 245
		this.m.StaminaModifier = -6; 	// Vanilla: -14
		this.m.Vision = -2;				// Vanilla: -2
	}
});
