::Hardened.HooksMod.hook("scripts/items/helmets/closed_mail_coif", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 450;				// Vanilla: 250
		this.m.ConditionMax = 100; 		// Vanilla: 90
		this.m.StaminaModifier = -6; 	// Vanilla: -4
		this.m.Vision = -1;				// Vanilla: 0
	}
});
