::Hardened.HooksMod.hook("scripts/items/helmets/named/norse_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 3000;			// Vanilla: 2000
		this.m.ConditionMax = 170; 		// Vanilla: 125
		this.m.StaminaModifier = -8; 	// Vanilla: -6
		this.m.Vision = -3;				// Vanilla: -1
	}
});
