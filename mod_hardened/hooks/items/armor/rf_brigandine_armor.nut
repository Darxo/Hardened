::Hardened.HooksMod.hook("scripts/items/armor/rf_brigandine_armor", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 3000;			// In Reforged this is 4600
		this.m.ConditionMax = 150; 		// In Reforged this is 230
		this.m.StaminaModifier = -14; 	// In Reforged this is -26
	}
});
