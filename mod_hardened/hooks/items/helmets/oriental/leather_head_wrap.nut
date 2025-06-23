::Hardened.HooksMod.hook("scripts/items/helmets/oriental/leather_head_wrap", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 80;				// Vanilla: 60
		this.m.ConditionMax = 50; 		// Vanilla: 40
		this.m.StaminaModifier = -5; 	// Vanilla: -2
		this.m.Vision = -1;				// Vanilla: 0
	}
});
