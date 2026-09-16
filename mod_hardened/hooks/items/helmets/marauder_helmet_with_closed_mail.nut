::Hardened.HooksMod.hook("scripts/items/helmets/marauder_helmet_with_closed_mail", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 1400;			// Vanilla: 1250
		this.m.ConditionMax = 250; 		// Vanilla: 245
		this.m.StaminaModifier = -20; 	// Vanilla: -20
		this.m.Vision = -3;				// Vanilla: -2
	}
});
