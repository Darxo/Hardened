::Hardened.HooksMod.hook("scripts/items/helmets/oriental/turban_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 3000;			// Vanilla: 3200
		this.m.ConditionMax = 280; 		// Vanilla: 290
		this.m.StaminaModifier = -19; 	// Vanilla: -20
		this.m.Vision = -3;				// Vanilla: -3
	}
});
