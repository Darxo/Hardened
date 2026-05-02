::Hardened.HooksMod.hook("scripts/items/armor/rf_draugr/rf_draugr_leather_and_bones_harness", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 1300;			// Reforged: 130
		this.m.ConditionMax = 170; 		// Reforged: 60
		this.m.StaminaModifier = -19;	// Reforged: -6
	}
});
