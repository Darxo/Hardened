::Hardened.HooksMod.hook("scripts/items/helmets/marauder_helmet_with_rusty_mail", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 900;				// Vanilla: 700
		this.m.ConditionMax = 180; 		// Vanilla: 180
		this.m.StaminaModifier = -14; 	// Vanilla: -14
		this.m.Vision = -3;				// Vanilla: -2
	}
});
