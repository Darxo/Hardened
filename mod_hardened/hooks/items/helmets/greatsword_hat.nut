::Hardened.HooksMod.hook("scripts/items/helmets/greatsword_hat", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 900;				// Vanilla: 200; Reforged: 1000
		this.m.ConditionMax = 60; 		// Vanilla: 70; Reforged: 90
		this.m.StaminaModifier = -1; 	// Vanilla: -3
		this.m.Vision = -1;				// Vanilla: 0
	}
});
