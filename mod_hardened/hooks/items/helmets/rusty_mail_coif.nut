::Hardened.HooksMod.hook("scripts/items/helmets/rusty_mail_coif", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 200;				// Vanilla: 150
		this.m.ConditionMax = 80; 		// Vanilla: 70
		this.m.StaminaModifier = -9; 	// Vanilla: -4
		this.m.Vision = 0;				// Vanilla: 0
	}
});
