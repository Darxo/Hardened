::Hardened.HooksMod.hook("scripts/items/helmets/rf_skull_cap", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 800;				// Vanilla: 800
		this.m.ConditionMax = 140; 		// Vanilla: 115
		this.m.StaminaModifier = -8; 	// Vanilla: -5
		this.m.Vision = -1;				// Vanilla: -1
	}
});
