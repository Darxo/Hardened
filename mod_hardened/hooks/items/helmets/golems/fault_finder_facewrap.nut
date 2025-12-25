::Hardened.HooksMod.hook("scripts/items/helmets/golems/fault_finder_facewrap", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 50;				// Vanilla: 0
		this.m.ConditionMax = 30; 		// Vanilla: 30
		this.m.StaminaModifier = -2; 	// Vanilla: 0
		this.m.Vision = -2;				// Vanilla: -3
	}
});
