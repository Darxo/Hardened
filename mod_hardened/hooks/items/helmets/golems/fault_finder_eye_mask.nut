::Hardened.HooksMod.hook("scripts/items/helmets/golems/fault_finder_eye_mask", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 200;				// Vanilla: 0
		this.m.ConditionMax = 20; 		// Vanilla: 10
		this.m.StaminaModifier = 0; 	// Vanilla: 0
		this.m.Vision = -3;				// Vanilla: -3
	}
});
