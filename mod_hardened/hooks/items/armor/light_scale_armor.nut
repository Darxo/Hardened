::Hardened.HooksMod.hook("scripts/items/armor/light_scale_armor", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// this.m.Value = 1300;			// In Vanilla this is 1300
		// this.m.ConditionMax = 170; 	// In Vanilla this is 170
		this.m.StaminaModifier = -19; 	// In Vanilla this is -21
	}
});
