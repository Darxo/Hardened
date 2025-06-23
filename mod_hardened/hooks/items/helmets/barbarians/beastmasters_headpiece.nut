::Hardened.HooksMod.hook("scripts/items/helmets/barbarians/beastmasters_headpiece", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 500;				// Vanilla: 350
		this.m.ConditionMax = 130;		// Vanilla: 130
		this.m.StaminaModifier = -8;	// Vanilla: -8
		this.m.Vision = -1;				// Vanilla: -1
	}
});
