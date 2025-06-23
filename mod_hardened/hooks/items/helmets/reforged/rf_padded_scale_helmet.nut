::Hardened.HooksMod.hook("scripts/items/helmets/rf_padded_scale_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 350;				// Vanilla: 375
		this.m.ConditionMax = 110; 		// Vanilla: 115
		this.m.StaminaModifier = -7; 	// Vanilla: -7
		this.m.Vision = -1;				// Vanilla: -1
	}
});
