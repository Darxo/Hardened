::Hardened.HooksMod.hook("scripts/items/helmets/oriental/southern_head_wrap", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 30;				// Vanilla: 50
		this.m.ConditionMax = 30; 		// Vanilla: 30
		this.m.StaminaModifier = -3; 	// Vanilla: 0
		this.m.Vision = -1;				// Vanilla: 0
	}
});
