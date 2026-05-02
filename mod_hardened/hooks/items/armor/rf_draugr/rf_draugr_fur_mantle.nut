::Hardened.HooksMod.hook("scripts/items/armor/rf_draugr/rf_draugr_fur_mantle", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 600;				// Reforged: 30
		this.m.ConditionMax = 130; 		// Reforged: 30
		this.m.StaminaModifier = -15;	// Reforged: -2
	}
});
