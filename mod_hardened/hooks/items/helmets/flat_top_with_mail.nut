::Hardened.HooksMod.hook("scripts/items/helmets/flat_top_with_mail", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 1800;			// Vanilla: 1800
		this.m.ConditionMax = 240;		// Vanilla: 230
		this.m.StaminaModifier = -16;	// Vanilla: -15
		this.m.Vision = -2;				// Vanilla: -2; Reforged: -1
	}
});
