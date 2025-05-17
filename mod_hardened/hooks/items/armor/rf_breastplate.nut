::Hardened.HooksMod.hook("scripts/items/armor/rf_breastplate", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 4200;			// In Reforged this is 3600
		this.m.ConditionMax = 230; 		// In Reforged this is 210
		this.m.StaminaModifier = -25; 	// In Reforged this is -24
	}
});
