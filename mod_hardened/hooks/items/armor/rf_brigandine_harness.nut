::Hardened.HooksMod.hook("scripts/items/armor/rf_brigandine_harness", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 4000;			// In Reforged this is 6000
		this.m.ConditionMax = 180; 		// In Reforged this is 270
		this.m.StaminaModifier = -18; 	// In Reforged this is -28
	}
});
