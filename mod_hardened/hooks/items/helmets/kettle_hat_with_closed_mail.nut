::Hardened.HooksMod.hook("scripts/items/helmets/kettle_hat_with_closed_mail", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// this.m.Value = 2200;				// Vanilla: 2200
		// this.m.ConditionMax = 250; 		// Vanilla: 250
		this.m.StaminaModifier = -18; 		// Vanilla: -17
		// this.m.Vision = -2;				// Vanilla: -2
	}
});
