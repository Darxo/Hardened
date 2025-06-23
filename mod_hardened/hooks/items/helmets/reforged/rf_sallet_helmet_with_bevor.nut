::Hardened.HooksMod.hook("scripts/items/helmets/rf_sallet_helmet_with_bevor", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 4500;			// Vanilla: 3500
		this.m.ConditionMax = 270; 		// Vanilla: 275
		this.m.StaminaModifier = -16; 	// Vanilla: -17
		this.m.Vision = -2;				// Vanilla: -2
	}
});
