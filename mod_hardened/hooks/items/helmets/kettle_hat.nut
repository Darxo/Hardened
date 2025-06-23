::Hardened.HooksMod.hook("scripts/items/helmets/kettle_hat", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 500;				// Vanilla: 450
		this.m.ConditionMax = 130;		// Vanilla: 115
		this.m.StaminaModifier = -8;	// Vanilla: -6
		this.m.Vision = -1;				// Vanilla: -1
	}
});
