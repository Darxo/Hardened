::Hardened.HooksMod.hook("scripts/items/helmets/oriental/heavy_lamellar_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 2500;			// Vanilla: 2500
		this.m.ConditionMax = 260; 		// Vanilla: 255
		this.m.StaminaModifier = -18; 	// Vanilla: -17
		this.m.Vision = -2;				// Vanilla: -2
	}
});
