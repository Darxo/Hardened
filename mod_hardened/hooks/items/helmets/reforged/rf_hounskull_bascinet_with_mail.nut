::Hardened.HooksMod.hook("scripts/items/helmets/rf_hounskull_bascinet_with_mail", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 5000;			// Vanilla: 6500
		this.m.ConditionMax = 350; 		// Vanilla: 340
		this.m.StaminaModifier = -25; 	// Vanilla: -22
		this.m.Vision = -3;				// Vanilla: -3
	}
});
