::Hardened.HooksMod.hook("scripts/items/armor/monk_robe", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 50;				// In Vanilla this is 45
		this.m.ConditionMax = 30; 		// In Vanilla this is 20
		this.m.StaminaModifier = -5; 	// In Vanilla this is 0
	}
});
