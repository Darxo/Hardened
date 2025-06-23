::Hardened.HooksMod.hook("scripts/items/helmets/rf_half_closed_sallet_with_bevor", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 4800;			// Vanilla: 5000
		this.m.ConditionMax = 330; 		// Vanilla: 315
		this.m.StaminaModifier = -23; 	// Vanilla: -20
		this.m.Vision = -3;				// Vanilla: -3
	}
});
