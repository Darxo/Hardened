::Hardened.HooksMod.hook("scripts/items/armor/undertaker_apron", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 80;				// In Vanilla this is 65
		this.m.ConditionMax = 40; 		// In Vanilla this is 30
		this.m.StaminaModifier = -5; 	// In Vanilla this is 0
	}
});
