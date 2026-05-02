::Hardened.HooksMod.hook("scripts/items/armor/rf_draugr/rf_draugr_runic_metal_armor", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 4200;			// Reforged: 550
		this.m.ConditionMax = 230;		// Reforged: 105
		this.m.StaminaModifier = -25	// Reforged: -12
	}
});
