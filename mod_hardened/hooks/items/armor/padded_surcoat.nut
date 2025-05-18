::Hardened.HooksMod.hook("scripts/items/armor/padded_surcoat", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 100;				// In Vanilla this is 90
		this.m.ConditionMax = 60; 		// In Vanilla this is 50
		this.m.StaminaModifier = -8; 	// In Vanilla this is -4
	}
});
