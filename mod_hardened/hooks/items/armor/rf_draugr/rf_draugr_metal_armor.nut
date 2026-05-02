::Hardened.HooksMod.hook("scripts/items/armor/rf_draugr/rf_draugr_metal_armor", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 1300;			// Reforged: 700
		this.m.ConditionMax = 170; 		// Reforged: 105
		this.m.StaminaModifier = -19;	// Reforged: -13
	}
});
