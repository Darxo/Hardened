::Hardened.HooksMod.hook("scripts/items/helmets/rf_conical_billed_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 2000;			// Vanilla: 2500
		this.m.ConditionMax = 140;		// Vanilla: 220
		this.m.StaminaModifier = -6;	// Vanilla: -12
		this.m.Vision = -2;				// Vanilla: -2
	}
});
