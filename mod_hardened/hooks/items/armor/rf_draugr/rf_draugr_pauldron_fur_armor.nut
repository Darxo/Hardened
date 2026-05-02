::Hardened.HooksMod.hook("scripts/items/armor/rf_draugr/rf_draugr_pauldron_fur_armor", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// Fix(Reforged): mismatching name and art
		this.m.VariantString = "rf_draugr_armor_16";	// Reforged: rf_draugr_armor_17
		this.updateVariant();

		this.m.Value = 600;				// Reforged: 500
		this.m.ConditionMax = 130; 		// Reforged: 35
		this.m.StaminaModifier = -15;	// Reforged: -3
	}
});
