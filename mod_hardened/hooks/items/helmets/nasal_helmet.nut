::Hardened.HooksMod.hook("scripts/items/helmets/nasal_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 350;				// Vanilla: 350
		this.m.ConditionMax = 120; 		// Vanilla: 105
		this.m.StaminaModifier = -7; 	// Vanilla: -5
		this.m.Vision = -2;				// Vanilla: -1
	}
});
