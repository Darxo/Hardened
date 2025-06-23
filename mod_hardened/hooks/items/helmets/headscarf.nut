::Hardened.HooksMod.hook("scripts/items/helmets/headscarf", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 20;				// Vanilla: 30
		this.m.ConditionMax = 20;		// Vanilla: 20
		this.m.StaminaModifier = -2;	// Vanilla: 0
		this.m.Vision = 0;				// Vanilla: 0
	}
});
