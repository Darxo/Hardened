::Hardened.HooksMod.hook("scripts/items/helmets/rf_sallet_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 1250;			// Vanilla: 1500
		this.m.ConditionMax = 150; 		// Vanilla: 150
		this.m.StaminaModifier = -8; 	// Vanilla: -7
		this.m.Vision = -1;				// Vanilla: -1
	}
});
