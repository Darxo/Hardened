::Hardened.HooksMod.hook("scripts/items/helmets/wizard_hat", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 300;				// Vanilla: 30
		this.m.ConditionMax = 50; 		// Vanilla: 30
		this.m.StaminaModifier = -2; 	// Vanilla: 0
		this.m.Vision = -1;				// Vanilla: 0
	}
});
