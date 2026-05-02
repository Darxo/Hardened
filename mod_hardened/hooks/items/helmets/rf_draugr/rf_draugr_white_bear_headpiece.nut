::Hardened.HooksMod.hook("scripts/items/helmets/rf_draugr/rf_draugr_white_bear_headpiece", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 500;				// Reforged: 120
		this.m.ConditionMax = 70; 		// Reforged: 60
		this.m.StaminaModifier = -4; 	// Reforged: -4
		this.m.Vision = -1;				// Reforged: 0
	}
});
