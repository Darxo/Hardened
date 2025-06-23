::Hardened.HooksMod.hook("scripts/items/helmets/hunters_hat", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 70;				// Vanilla: 70
		this.m.ConditionMax = 30;		// Vanilla: 30
		this.m.StaminaModifier = -2;	// Vanilla: 0
		this.m.Vision = 0;				// Vanilla: 0
	}
});
