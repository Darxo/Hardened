::Hardened.HooksMod.hook("scripts/items/helmets/rf_draugr/rf_draugr_claw_headband", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 30;				// Reforged: 60
		this.m.ConditionMax = 30; 		// Reforged: 50
		this.m.StaminaModifier = -3; 	// Reforged: 0
		this.m.Vision = -1;				// Reforged: 0
	}
});
