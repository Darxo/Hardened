::Hardened.HooksMod.hook("scripts/items/helmets/witchhunter_hat", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 120;				// Vanilla: 100
		this.m.ConditionMax = 50; 		// Vanilla: 40
		this.m.StaminaModifier = -3; 	// Vanilla: 0
		this.m.Vision = -1;				// Vanilla: 0
	}
});
