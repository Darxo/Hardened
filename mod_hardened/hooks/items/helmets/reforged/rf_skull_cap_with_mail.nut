::Hardened.HooksMod.hook("scripts/items/helmets/rf_skull_cap_with_mail", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 1250;			// Vanilla: 2000
		this.m.ConditionMax = 190; 		// Vanilla: 210
		this.m.StaminaModifier = -14; 	// Vanilla: -12
		this.m.Vision = -1;				// Vanilla: -2
	}
});
