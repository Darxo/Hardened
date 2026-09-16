::Hardened.HooksMod.hook("scripts/items/helmets/kettle_hat_with_rusty_mail", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 1700;			// Vanilla: 1250
		this.m.ConditionMax = 220;		// Vanilla: 245
		this.m.StaminaModifier = -20;	// Vanilla: -20
		this.m.Vision = -1;				// Vanilla: -2
	}
});
