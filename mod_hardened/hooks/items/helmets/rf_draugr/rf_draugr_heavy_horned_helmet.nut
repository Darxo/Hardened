::Hardened.HooksMod.hook("scripts/items/helmets/rf_draugr/rf_draugr_heavy_horned_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 1250;			// Reforged: 750
		this.m.ConditionMax = 150; 		// Reforged: 160
		this.m.StaminaModifier = -8; 	// Reforged: -15
		this.m.Vision = -1;				// Reforged: -1
	}
});
