::Hardened.HooksMod.hook("scripts/items/armor/rf_draugr/rf_draugr_pauldron_armor", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// Fix(Reforged): mismatching name and art
		this.m.VariantString = "rf_draugr_armor_17";	// Reforged: rf_draugr_armor_16
		this.updateVariant();

		this.m.Value = 90;				// Reforged: 500
		this.m.ConditionMax = 50; 		// Reforged: 20
		this.m.StaminaModifier = -7;	// Reforged: -2
	}
});
