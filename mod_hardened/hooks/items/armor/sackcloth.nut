::Hardened.HooksMod.hook("scripts/items/armor/sackcloth", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 30;				// In Vanilla this is 20
		this.m.ConditionMax = 20; 		// In Vanilla this is 10
		this.m.StaminaModifier = -4; 	// In Vanilla this is 0
	}
});
