::Hardened.HooksMod.hook("scripts/items/helmets/barbute_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 2500;			// Vanilla: 2600
		this.m.ConditionMax = 180;		// Vanilla: 190
		this.m.StaminaModifier = -9;	// Vanilla: -9
		this.m.Vision = -2;				// Vanilla: -2
	}
});
