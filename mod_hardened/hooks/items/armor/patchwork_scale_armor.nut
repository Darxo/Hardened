::Hardened.HooksMod.hook("scripts/items/armor/patchwork_scale_armor", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 2200;			// Vanilla: 2000
		this.m.ConditionMax = 200; 		// Vanilla: 220
		this.m.StaminaModifier = -30;	// Vanilla: -29
	}
});
