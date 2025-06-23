::Hardened.HooksMod.hook("scripts/items/helmets/decayed_full_helm", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 1500;			// Vanilla: 1500
		this.m.ConditionMax = 240;		// Vanilla: 240
		this.m.StaminaModifier = -20;	// Vanilla: -20
		this.m.Vision = -3;				// Vanilla: -3
	}
});
