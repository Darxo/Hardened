::Hardened.HooksMod.hook("scripts/items/armor/reinforced_leather_tunic", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 300;				// In Vanilla this is 300
		this.m.ConditionMax = 90; 		// In Vanilla this is 100
		this.m.StaminaModifier = -10; 	// In Vanilla this is -9
	}
});
