::Hardened.HooksMod.hook("scripts/items/helmets/full_aketon_cap", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 100;				// Vanilla: 100
		this.m.ConditionMax = 60;		// Vanilla: 50
		this.m.StaminaModifier = -6;	// Vanilla: -2
		this.m.Vision = -1;				// Vanilla: 0
	}
});
