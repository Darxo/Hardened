::Hardened.HooksMod.hook("scripts/items/helmets/kettle_hat_with_mail", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 1700;			// Vanilla: 1500
		this.m.ConditionMax = 230;		// Vanilla: 215
		this.m.StaminaModifier = -16;	// Vanilla: -14
		this.m.Vision = -1;				// Vanilla: -2
	}
});
