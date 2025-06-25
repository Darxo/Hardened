::Hardened.HooksMod.hook("scripts/items/helmets/oriental/southern_helmet_with_coif", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 1250;				// Vanilla: 1250
		this.m.ConditionMax = 180; 			// Vanilla: 200
		this.m.StaminaModifier = -12; 		// Vanilla: -12
		this.m.Vision = -1;					// Vanilla: -2
	}
});
