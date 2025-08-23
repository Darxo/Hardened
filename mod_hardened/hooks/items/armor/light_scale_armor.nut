::Hardened.HooksMod.hook("scripts/items/armor/light_scale_armor", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 1000;			// In Vanilla this is 1300
		// this.m.ConditionMax = 170; 	// In Vanilla this is 170
		// this.m.StaminaModifier = -21; // In Vanilla this is -21
	}
});
