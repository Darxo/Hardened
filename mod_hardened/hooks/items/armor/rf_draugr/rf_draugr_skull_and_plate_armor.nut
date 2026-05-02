::Hardened.HooksMod.hook("scripts/items/armor/rf_draugr/rf_draugr_skull_and_plate_armor", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 600;				// Reforged: 300
		this.m.ConditionMax = 130; 		// Reforged: 80
		this.m.StaminaModifier = -15;	// Reforged: -10
	}
});
