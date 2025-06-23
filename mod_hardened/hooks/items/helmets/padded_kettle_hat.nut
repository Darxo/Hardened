::Hardened.HooksMod.hook("scripts/items/helmets/padded_kettle_hat", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 500;				// Vanilla: 650
		this.m.ConditionMax = 130; 		// Vanilla: 140
		this.m.StaminaModifier = -8; 	// Vanilla: -8
		this.m.Vision = -1;				// Vanilla: -1
	}
});
