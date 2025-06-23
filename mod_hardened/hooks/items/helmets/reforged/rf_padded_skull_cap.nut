::Hardened.HooksMod.hook("scripts/items/helmets/rf_padded_skull_cap", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 800;				// Vanilla: 1200
		this.m.ConditionMax = 140; 		// Vanilla: 140
		this.m.StaminaModifier = -8; 	// Vanilla: -7
		this.m.Vision = -1;				// Vanilla: -1
	}
});
