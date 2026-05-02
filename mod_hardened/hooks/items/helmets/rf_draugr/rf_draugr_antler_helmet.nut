::Hardened.HooksMod.hook("scripts/items/helmets/rf_draugr/rf_draugr_antler_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 2500;			// Reforged: 1000
		this.m.ConditionMax = 180;		// Reforged: 180
		this.m.StaminaModifier = -9;	// Reforged: -16
		this.m.Vision = -2;				// Reforged: -2
	}
});
