::Hardened.HooksMod.hook("scripts/items/helmets/nordic_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 1500;			// Vanilla: 500; Reforged: 750
		this.m.ConditionMax = 170; 		// Vanilla: 125; Reforged: 135
		this.m.StaminaModifier = -8; 	// Vanilla: -7
		this.m.Vision = -3;				// Vanilla: -1
	}
});
