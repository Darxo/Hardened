::Hardened.HooksMod.hook("scripts/items/helmets/flat_top_with_rusty_mail", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 1400;			// Vanilla: 1250
		this.m.ConditionMax = 240; 		// Vanilla: 245
		this.m.StaminaModifier = -20; 	// Vanilla: -20
		this.m.Vision = -2;				// Vanilla: -2
	}
});
