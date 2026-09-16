::Hardened.HooksMod.hook("scripts/items/armor/pillaged_heavy_lamellar_armor", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 2200;			// Vanilla: 2750
		this.m.ConditionMax = 250; 		// Vanilla: 255
		this.m.StaminaModifier = -40;	// Vanilla: -42
	}
});
