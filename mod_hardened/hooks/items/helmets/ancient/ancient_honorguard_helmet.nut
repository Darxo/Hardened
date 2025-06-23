::Hardened.HooksMod.hook("scripts/items/helmets/ancient/ancient_honorguard_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 900;				// Vanilla: 1000
		this.m.ConditionMax = 180;		// Vanilla: 180
		this.m.StaminaModifier = -15;	// Vanilla: -13
		this.m.Vision = -3;				// Vanilla: -3
	}
});
