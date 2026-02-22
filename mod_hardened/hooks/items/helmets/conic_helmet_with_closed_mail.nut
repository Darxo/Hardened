::Hardened.HooksMod.hook("scripts/items/helmets/conic_helmet_with_closed_mail", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 2600;			// Vanilla: 2600; Reforged: 2800
		this.m.ConditionMax = 260; 		// Vanilla: 265; Reforged: 275
		this.m.StaminaModifier = -17; 	// Vanilla: -18
		this.m.Vision = -3;				// Vanilla: -2; Reforged: -3
	}
});
