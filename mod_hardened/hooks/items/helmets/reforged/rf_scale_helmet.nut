::Hardened.HooksMod.hook("scripts/items/helmets/rf_scale_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 350;				// Vanilla: 300
		this.m.ConditionMax = 110; 		// Vanilla: 90
		this.m.StaminaModifier = -7; 	// Vanilla: -5
		this.m.Vision = -1;				// Vanilla: -1
	}
});
