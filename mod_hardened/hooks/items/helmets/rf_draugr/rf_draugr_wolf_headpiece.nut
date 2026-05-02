::Hardened.HooksMod.hook("scripts/items/helmets/rf_draugr/rf_draugr_wolf_headpiece", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 500;				// Reforged: 100
		this.m.ConditionMax = 70; 		// Reforged: 50
		this.m.StaminaModifier = -4; 	// Reforged: -3
		this.m.Vision = -1;				// Reforged: 0
	}
});
