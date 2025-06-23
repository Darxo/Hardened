::Hardened.HooksMod.hook("scripts/items/helmets/flat_top_with_closed_mail", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 2500;			// Vanilla: 2600
		this.m.ConditionMax = 260;		// Vanilla: 265
		this.m.StaminaModifier = -18;	// Vanilla: -18
		this.m.Vision = -2;				// Vanilla: -2
	}
});
