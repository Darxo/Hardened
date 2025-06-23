::Hardened.HooksMod.hook("scripts/items/helmets/oriental/desert_stalker_head_wrap", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 900;				// Vanilla: 120
		this.m.ConditionMax = 40; 		// Vanilla: 45
		this.m.StaminaModifier = -1; 	// Vanilla: 0
		this.m.Vision = 0;				// Vanilla: 0
	}
});
