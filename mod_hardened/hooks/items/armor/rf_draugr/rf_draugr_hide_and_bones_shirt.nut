::Hardened.HooksMod.hook("scripts/items/armor/rf_draugr/rf_draugr_hide_and_bones_shirt", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 600;				// Reforged: 80
		this.m.ConditionMax = 130; 		// Reforged: 45
		this.m.StaminaModifier = -15;	// Reforged: -3
	}
});
