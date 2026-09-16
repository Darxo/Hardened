::Hardened.HooksMod.hook("scripts/items/helmets/bascinet_faction_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 2000;			// Vanilla: 1400
		this.m.ConditionMax = 250;		// Vanilla: 220
		this.m.StaminaModifier = -16;	// Vanilla: -13
		this.m.Vision = -2;				// Vanilla: -2
	}
});
