::Hardened.HooksMod.hook("scripts/items/armor/wanderers_coat", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 150;				// In Vanilla this is 180
		this.m.ConditionMax = 70; 		// In Vanilla this is 65
		this.m.StaminaModifier = -8; 	// In Vanilla this is -5
	}
});
