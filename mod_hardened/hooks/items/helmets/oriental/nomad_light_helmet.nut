::Hardened.HooksMod.hook("scripts/items/helmets/oriental/nomad_light_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 120;				// Vanilla: 140
		this.m.ConditionMax = 60; 		// Vanilla: 70
		this.m.StaminaModifier = -5; 	// Vanilla: -3
		this.m.Vision = -1;				// Vanilla: 0
	}
});
