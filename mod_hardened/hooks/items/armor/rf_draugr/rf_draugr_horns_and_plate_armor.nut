::Hardened.HooksMod.hook("scripts/items/armor/rf_draugr/rf_draugr_horns_and_plate_armor", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 4200;			// Reforged: 450
		this.m.ConditionMax = 230;		// Reforged: 90
		this.m.StaminaModifier = -25	// Reforged: -8
	}
});
