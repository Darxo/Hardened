::Hardened.HooksMod.hook("scripts/items/helmets/rf_draugr/rf_draugr_headwrap", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 20;				// Reforged: 40
		this.m.ConditionMax = 20; 		// Reforged: 30
		this.m.StaminaModifier = -2; 	// Reforged: 0
		this.m.Vision = 0;				// Reforged: 0
	}
});
