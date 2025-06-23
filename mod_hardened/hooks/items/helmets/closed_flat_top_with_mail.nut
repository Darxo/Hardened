::Hardened.HooksMod.hook("scripts/items/helmets/closed_flat_top_with_mail", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 300;				// Vanilla: 3000
		this.m.ConditionMax = 280;		// Vanilla: 280
		this.m.StaminaModifier = -19;	// Vanilla: -19
		this.m.Vision = -3;				// Vanilla: -3
	}
});
