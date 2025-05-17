::Hardened.HooksMod.hook("scripts/items/armor/leather_lamellar", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 250;				// In Vanilla this is 300
		this.m.ConditionMax = 90; 		// In Vanilla this is 95
		this.m.StaminaModifier = -11; 	// In Vanilla this is -10
	}
});
