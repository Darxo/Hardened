::Hardened.HooksMod.hook("scripts/items/helmets/mail_coif", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 350;				// Vanilla: 200
		this.m.ConditionMax = 80;		// Vanilla: 80
		this.m.StaminaModifier = -6; 	// Vanilla: -4
		this.m.Vision = 0;				// Vanilla: 0
	}
});
