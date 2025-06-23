::Hardened.HooksMod.hook("scripts/items/helmets/rf_half_closed_sallet_with_mail", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 4500;			// Vanilla: 4000
		this.m.ConditionMax = 280; 		// Vanilla: 290
		this.m.StaminaModifier = -16; 	// Vanilla: -18
		this.m.Vision = -3;				// Vanilla: -2
	}
});
