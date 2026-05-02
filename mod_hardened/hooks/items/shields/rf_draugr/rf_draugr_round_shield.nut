::Hardened.HooksMod.hook("scripts/items/shields/rf_draugr/rf_draugr_round_shield", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Description = "An old wooden round shield.";

		this.m.Value = 160				// Reforged: 60
		this.m.ConditionMax = 24;		// Reforged: 48
		this.m.MeleeDefense = 15;		// Reforged: 18
		this.m.RangedDefense = 15;		// Reforged: 18
		this.m.StaminaModifier = -10;	// Reforged: 15
	}
});
