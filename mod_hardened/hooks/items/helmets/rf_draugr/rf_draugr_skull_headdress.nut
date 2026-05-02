::Hardened.HooksMod.hook("scripts/items/helmets/rf_draugr/rf_draugr_skull_headdress", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 500;				// Reforged: 250
		this.m.ConditionMax = 70; 		// Reforged: 70
		this.m.StaminaModifier = -4; 	// Reforged: -5
		this.m.Vision = -1;				// Reforged: -1
	}
});
