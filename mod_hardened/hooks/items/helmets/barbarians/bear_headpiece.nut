::Hardened.HooksMod.hook("scripts/items/helmets/barbarians/bear_headpiece", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 80;				// Vanilla: 100
		this.m.ConditionMax = 60; 		// Vanilla: 50
		this.m.StaminaModifier = -7; 	// Vanilla: -3
		this.m.Vision = -1;				// Vanilla: 0
	}
});
