::Hardened.HooksMod.hook("scripts/items/helmets/padded_nasal_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 350;				// Vanilla: 550
		this.m.ConditionMax = 120; 		// Vanilla: 130
		this.m.StaminaModifier = -7; 	// Vanilla: -7
		this.m.Vision = -2;				// Vanilla: -1
	}
});
