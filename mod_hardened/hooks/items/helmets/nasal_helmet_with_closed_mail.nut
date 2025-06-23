::Hardened.HooksMod.hook("scripts/items/helmets/nasal_helmet_with_closed_mail", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 2200;			// Vanilla: 2000
		this.m.ConditionMax = 250; 		// Vanilla: 240
		this.m.StaminaModifier = -18; 	// Vanilla: -16
		this.m.Vision = -2;				// Vanilla: -2
	}
});
