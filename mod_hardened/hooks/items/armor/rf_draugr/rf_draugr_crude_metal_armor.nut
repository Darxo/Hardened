::Hardened.HooksMod.hook("scripts/items/armor/rf_draugr/rf_draugr_crude_metal_armor", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 1300;			// Reforged: 500
		this.m.ConditionMax = 170; 		// Reforged: 100
		this.m.StaminaModifier = -19;	// Reforged: -12
	}
});
