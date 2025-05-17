::Hardened.HooksMod.hook("scripts/items/armor/rf_brigandine_shirt", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 2000;			// In Reforged this is 3000
		this.m.ConditionMax = 110; 		// In Reforged this is 190
		this.m.StaminaModifier = -9; 	// In Reforged this is -21
	}
});
