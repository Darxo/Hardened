::Hardened.HooksMod.hook("scripts/items/armor/golems/fault_finder_robes", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 400;				// In Vanilla this is 190
		this.m.ConditionMax = 80; 		// In Vanilla this is 75
		// this.m.StaminaModifier = -7; // In Vanilla this is -7
	}
});
