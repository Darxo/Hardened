::Hardened.HooksMod.hook("scripts/items/helmets/aketon_cap", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 80;				// Vanilla: 70
		this.m.ConditionMax = 40;		// Vanilla: 40
		this.m.StaminaModifier = -4; 	// Vanilla: 0
		this.m.Vision = 0;				// Vanilla: 0
	}
});
