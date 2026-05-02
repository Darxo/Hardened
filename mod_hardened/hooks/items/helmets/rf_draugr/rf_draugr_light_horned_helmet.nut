::Hardened.HooksMod.hook("scripts/items/helmets/rf_draugr/rf_draugr_light_horned_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 1250;			// Reforged: 400
		this.m.ConditionMax = 150; 		// Reforged: 120
		this.m.StaminaModifier = -8; 	// Reforged: -8
		this.m.Vision = -1;				// Reforged: -1
	}
});
