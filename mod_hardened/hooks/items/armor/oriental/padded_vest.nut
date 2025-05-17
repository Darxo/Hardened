::Hardened.HooksMod.hook("scripts/items/armor/oriental/padded_vest", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 120;				// In Vanilla this is 140
		// this.m.ConditionMax = 60; 	// In Vanilla this is 60
		this.m.StaminaModifier = -7; 	// In Vanilla this is -5
	}
});
