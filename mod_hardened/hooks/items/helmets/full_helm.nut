::Hardened.HooksMod.hook("scripts/items/helmets/full_helm", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 3500;			// Vanilla: 3500
		this.m.ConditionMax = 300;		// Vanilla: 300
		this.m.StaminaModifier = -20;	// Vanilla: -20
		this.m.Vision = -3;				// Vanilla: -3
	}
});
