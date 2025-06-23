::Hardened.HooksMod.hook("scripts/items/helmets/closed_flat_top_with_neckguard", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 1100;			// Vanilla: 1100
		this.m.ConditionMax = 180;		// Vanilla: 180
		this.m.StaminaModifier = -12; 	// Vanilla: -11
		this.m.Vision = -3;				// Vanilla: -3
	}
});
