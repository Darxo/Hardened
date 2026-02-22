::Hardened.HooksMod.hook("scripts/items/helmets/oriental/spiked_skull_cap_with_mail", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 500;				// Vanilla: 500
		this.m.ConditionMax = 130; 		// Vanilla: 125
		this.m.StaminaModifier = -8; 	// Vanilla: -7
		this.m.Vision = -1;				// Vanilla: -1; Reforged: 0
	}
});
