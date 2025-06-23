::Hardened.HooksMod.hook("scripts/items/helmets/adorned_closed_flat_top_with_mail", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 2200;			// Vanilla: 2000; Reforged: 1200
		this.m.ConditionMax = 260; 		// Vanilla: 250; Reforged: 230
		this.m.StaminaModifier = -17; 	// Vanilla: -15; Reforged: -12
		this.m.Vision = -3;				// Vanilla: -3
	}
});
