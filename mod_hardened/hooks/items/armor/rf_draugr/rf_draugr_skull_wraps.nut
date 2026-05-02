::Hardened.HooksMod.hook("scripts/items/armor/rf_draugr/rf_draugr_skull_wraps", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 90;				// Reforged: 20
		this.m.ConditionMax = 50; 		// Reforged: 15
		this.m.StaminaModifier = -7;	// Reforged: -2
	}
});
