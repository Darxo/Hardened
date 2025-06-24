::Hardened.HooksMod.hook("scripts/items/helmets/ancient/ancient_legionary_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 400;				// Vanilla: 600
		this.m.ConditionMax = 130;		// Vanilla: 130
		this.m.StaminaModifier = -10;	// Vanilla: -10
		this.m.Vision = -2;				// Vanilla: -2
	}
});
