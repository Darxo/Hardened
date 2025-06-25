::Hardened.HooksMod.hook("scripts/items/helmets/oriental/wrapped_southern_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 450;				// Vanilla: 350
		this.m.ConditionMax = 100;		// Vanilla: 105
		this.m.StaminaModifier = -6;	// Vanilla: -5
		this.m.Vision = -1;				// Vanilla: -1
	}
});
