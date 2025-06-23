::Hardened.HooksMod.hook("scripts/items/helmets/rf_sallet_helmet_with_mail", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 2000;			// Vanilla: 2500
		this.m.ConditionMax = 180; 		// Vanilla: 240
		this.m.StaminaModifier = -11; 	// Vanilla: -14
		this.m.Vision = -1;				// Vanilla: -2
	}
});
