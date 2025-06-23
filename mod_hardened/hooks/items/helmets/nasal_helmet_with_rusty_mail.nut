::Hardened.HooksMod.hook("scripts/items/helmets/nasal_helmet_with_rusty_mail", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 400;				// Vanilla: 600
		this.m.ConditionMax = 130; 		// Vanilla: 140
		this.m.StaminaModifier = -10; 	// Vanilla: -9
		this.m.Vision = -2;				// Vanilla: -2
	}
});
