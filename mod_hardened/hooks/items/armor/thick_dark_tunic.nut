::Hardened.HooksMod.hook("scripts/items/armor/thick_dark_tunic", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 80;				// In Vanilla this is 75
		this.m.ConditionMax = 40; 		// In Vanilla this is 35
		this.m.StaminaModifier = -5; 	// In Vanilla this is -2
	}
});
