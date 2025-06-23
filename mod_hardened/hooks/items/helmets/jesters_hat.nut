::Hardened.HooksMod.hook("scripts/items/helmets/jesters_hat", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 40;				// Vanilla: 70
		this.m.ConditionMax = 40; 		// Vanilla: 30
		this.m.StaminaModifier = -6; 	// Vanilla: 0
		this.m.Vision = -1;				// Vanilla: 0
	}
});
