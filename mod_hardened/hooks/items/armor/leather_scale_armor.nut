::Hardened.HooksMod.hook("scripts/items/armor/leather_scale_armor", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// this.m.Value = 800;			// In Vanilla this is 800
		// this.m.ConditionMax = 140; 	// In Vanilla this is 140
		this.m.StaminaModifier = -15; 	// In Vanilla this is -16
	}
});
