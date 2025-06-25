::Hardened.HooksMod.hook("scripts/items/helmets/decayed_closed_flat_top_with_mail", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 1250;			// Vanilla: 1250
		this.m.ConditionMax = 220;		// Vanilla: 230
		this.m.StaminaModifier = -18;	// Vanilla: -19
		this.m.Vision = -3;				// Vanilla: -3
	}
});
