::Hardened.HooksMod.hook("scripts/items/helmets/named/wolf_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 3000;			// Vanilla: 2000
		this.m.ConditionMax = 120; 		// Vanilla: 140
		this.m.StaminaModifier = -6; 	// Vanilla: -8
		this.m.Vision = -1;				// Vanilla: 0
	}
});
