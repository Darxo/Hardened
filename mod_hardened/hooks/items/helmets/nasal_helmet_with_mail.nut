::Hardened.HooksMod.hook("scripts/items/helmets/nasal_helmet_with_mail", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 1250;			// Vanilla: 1250
		this.m.ConditionMax = 200; 		// Vanilla: 200
		this.m.StaminaModifier = -14; 	// Vanilla: -12
		this.m.Vision = -2;				// Vanilla: -2
	}
});
