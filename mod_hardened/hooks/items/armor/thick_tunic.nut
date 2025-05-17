::Hardened.HooksMod.hook("scripts/items/armor/thick_tunic", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 70;				// In Vanilla this is 75
		this.m.ConditionMax = 40; 		// In Vanilla this is 35
		this.m.StaminaModifier = -6; 	// In Vanilla this is -3
	}
});
