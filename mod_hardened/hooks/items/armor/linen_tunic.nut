::Hardened.HooksMod.hook("scripts/items/armor/linen_tunic", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// this.m.Value = 45;			// In Vanilla this is 45
		// this.m.ConditionMax = 20;	// In Vanilla this is 20
		this.m.StaminaModifier = -3; 	// In Vanilla this is 0
	}
});
