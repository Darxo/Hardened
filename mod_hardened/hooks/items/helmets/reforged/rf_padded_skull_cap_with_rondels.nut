::Hardened.HooksMod.hook("scripts/items/helmets/rf_padded_skull_cap_with_rondels", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 1250;			// Vanilla: 1500
		this.m.ConditionMax = 150; 		// Vanilla: 160
		this.m.StaminaModifier = -8; 	// Vanilla: -8
		this.m.Vision = -1;				// Vanilla: -1
	}
});
