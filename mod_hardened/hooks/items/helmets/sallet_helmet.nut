::Hardened.HooksMod.hook("scripts/items/helmets/sallet_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 2000;			// Vanilla: 1200; Reforged: 1500
		this.m.ConditionMax = 120; 		// Vanilla: 120; Reforged: 125
		this.m.StaminaModifier = -7; 	// Vanilla: -5
		this.m.Vision = 0;				// Vanilla: 0
	}
});
