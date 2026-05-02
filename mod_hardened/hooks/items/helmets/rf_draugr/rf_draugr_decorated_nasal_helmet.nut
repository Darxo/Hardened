::Hardened.HooksMod.hook("scripts/items/helmets/rf_draugr/rf_draugr_decorated_nasal_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 2500;			// Reforged: 750
		this.m.ConditionMax = 180;		// Reforged: 150
		this.m.StaminaModifier = -9;	// Reforged: -11
		this.m.Vision = -2;				// Reforged: -1
	}
});
