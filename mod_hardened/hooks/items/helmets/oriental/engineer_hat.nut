::Hardened.HooksMod.hook("scripts/items/helmets/oriental/engineer_hat", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 500;				// Vanilla: 50
		this.m.ConditionMax = 60; 		// Vanilla: 30
		this.m.StaminaModifier = -4; 	// Vanilla: 0
		this.m.Vision = 0;				// Vanilla: 0
	}
});
