::Hardened.HooksMod.hook("scripts/items/helmets/oriental/assassin_head_wrap", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 900;				// Vanilla: 60
		this.m.ConditionMax = 70; 		// Vanilla: 40
		this.m.StaminaModifier = -1; 	// Vanilla: 0
		this.m.Vision = -2;				// Vanilla: 0
	}
});
