::Hardened.HooksMod.hook("scripts/items/helmets/rf_draugr/rf_draugr_headband", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 20;				// Reforged: 20
		this.m.ConditionMax = 20; 		// Reforged: 20
		this.m.StaminaModifier = -2; 	// Reforged: 0
		this.m.Vision = 0;				// Reforged: 0
	}
});
