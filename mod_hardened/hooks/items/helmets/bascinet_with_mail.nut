::Hardened.HooksMod.hook("scripts/items/helmets/bascinet_with_mail", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 1400;			// Vanilla: 1400
		this.m.ConditionMax = 230; 		// Vanilla: 210
		this.m.StaminaModifier = -16; 	// Vanilla: -13
		this.m.Vision = -2;				// Vanilla: -2; Reforged: -1
	}
});
