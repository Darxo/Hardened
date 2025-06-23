::Hardened.HooksMod.hook("scripts/items/helmets/masked_kettle_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 500;				// Vanilla: 550; Reforged: 1000
		this.m.ConditionMax = 140; 		// Vanilla: 120; Reforged: 125
		this.m.StaminaModifier = -8; 	// Vanilla: -6
		this.m.Vision = -3;				// Vanilla: -2
	}
});
