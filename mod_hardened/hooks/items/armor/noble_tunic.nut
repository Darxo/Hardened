::Hardened.HooksMod.hook("scripts/items/armor/noble_tunic", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// this.m.Value = 100;			// In Vanilla this is 100
		this.m.ConditionMax = 30; 		// In Vanilla this is 20
		this.m.StaminaModifier = -2; 	// In Vanilla this is 0
	}
});
