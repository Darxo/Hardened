::Hardened.HooksMod.hook("scripts/items/helmets/barbarians/leather_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 200;				// Vanilla: 320
		this.m.ConditionMax = 100;		// Vanilla: 105
		this.m.StaminaModifier = -7;	// Vanilla: -6
		this.m.Vision = -2;				// Vanilla: -1; Reforged: -2
	}
});
