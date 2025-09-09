::Hardened.HooksMod.hook("scripts/items/helmets/oriental/blade_dancer_head_wrap", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 900;				// Vanilla: 150
		this.m.ConditionMax = 70; 		// Vanilla: 60
		this.m.StaminaModifier = -1; 	// Vanilla: -1
		this.m.Vision = -2;				// Vanilla: 0
	}
});
