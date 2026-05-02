::Hardened.HooksMod.hook("scripts/items/helmets/rf_draugr/rf_draugr_horned_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 1250;			// Reforged: 650
		this.m.ConditionMax = 150; 		// Reforged: 140
		this.m.StaminaModifier = -8; 	// Reforged: -11
		this.m.Vision = -1;				// Reforged: -1
	}
});
