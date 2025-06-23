::Hardened.HooksMod.hook("scripts/items/helmets/feathered_hat", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 50;				// Vanilla: 80
		this.m.ConditionMax = 40;		// Vanilla: 30
		this.m.StaminaModifier = -5;	// Vanilla: 0
		this.m.Vision = 0;				// Vanilla: 0
	}
});
