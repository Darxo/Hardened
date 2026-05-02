::Hardened.HooksMod.hook("scripts/items/armor/rf_draugr/rf_draugr_wolf_fur_mantle", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 400;				// Reforged: 120
		this.m.ConditionMax = 80; 		// Reforged: 50
		this.m.StaminaModifier = -7;	// Reforged: -3
	}
});
