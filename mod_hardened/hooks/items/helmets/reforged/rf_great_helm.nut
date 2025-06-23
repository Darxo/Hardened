::Hardened.HooksMod.hook("scripts/items/helmets/rf_great_helm", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 5200;			// Vanilla: 4500
		this.m.ConditionMax = 370; 		// Vanilla: 360
		this.m.StaminaModifier = -27; 	// Vanilla: -26
		this.m.Vision = -4;				// Vanilla: -4
	}
});
