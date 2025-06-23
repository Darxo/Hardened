::Hardened.HooksMod.hook("scripts/items/helmets/rf_padded_sallet_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 1250;			// Vanilla: 2000
		this.m.ConditionMax = 150; 		// Vanilla: 180
		this.m.StaminaModifier = -8; 	// Vanilla: -9
		this.m.Vision = -1;				// Vanilla: -1
	}
});
