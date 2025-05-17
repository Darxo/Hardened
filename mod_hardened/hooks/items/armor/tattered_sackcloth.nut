::Hardened.HooksMod.hook("scripts/items/armor/tattered_sackcloth", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// this.m.Value = 0;			// In Vanilla this is 0
		this.m.ConditionMax = 10; 		// In Vanilla this is 5
		this.m.StaminaModifier = -4; 	// In Vanilla this is 0
	}
});
