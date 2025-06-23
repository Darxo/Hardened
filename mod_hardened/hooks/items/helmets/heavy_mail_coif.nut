::Hardened.HooksMod.hook("scripts/items/helmets/heavy_mail_coif", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 600;				// Vanilla: 375
		this.m.ConditionMax = 120;		// Vanilla: 110
		this.m.StaminaModifier = -7;	// Vanilla: -5
		this.m.Vision = -1;				// Vanilla: 0
	}
});
