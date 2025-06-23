::Hardened.HooksMod.hook("scripts/items/helmets/oriental/nomad_reinforced_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 500;				// Vanilla: 450
		this.m.ConditionMax = 130; 		// Vanilla: 125
		this.m.StaminaModifier = -8; 	// Vanilla: -8
		this.m.Vision = -1;				// Vanilla: -1
	}
});
