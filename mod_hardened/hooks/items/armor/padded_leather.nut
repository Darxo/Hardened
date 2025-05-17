::Hardened.HooksMod.hook("scripts/items/armor/padded_leather", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 180;				// In Vanilla this is 200
		// this.m.ConditionMax = 80; 	// In Vanilla this is 80
		this.m.StaminaModifier = -10; 	// In Vanilla this is -8
	}
});
