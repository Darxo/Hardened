::Hardened.HooksMod.hook("scripts/items/armor/rf_draugr/rf_draugr_skull_and_bones_armor", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 1300;			// Reforged: 170
		this.m.ConditionMax = 170; 		// Reforged: 70
		this.m.StaminaModifier = -19;	// Reforged: -7
	}
});
