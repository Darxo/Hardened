::Hardened.HooksMod.hook("scripts/items/helmets/straw_hat", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 30;				// Vanilla: 60
		this.m.ConditionMax = 30; 		// Vanilla: 30
		this.m.StaminaModifier = -3; 	// Vanilla: 0
		this.m.Vision = -1;				// Vanilla: 0
	}
});
