::Hardened.HooksMod.hook("scripts/items/armor/apron", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 70;				// In Vanilla this is 55
		this.m.ConditionMax = 50; 		// In Vanilla this is 25
		this.m.StaminaModifier = -9; 	// In Vanilla this is 0
	}
});
