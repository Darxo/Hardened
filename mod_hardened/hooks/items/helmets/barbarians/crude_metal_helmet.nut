::Hardened.HooksMod.hook("scripts/items/helmets/barbarians/crude_metal_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 400;				// Vanilla: 550
		this.m.ConditionMax = 130;		// Vanilla: 145
		this.m.StaminaModifier = -11;	// Vanilla: -11
		this.m.Vision = -1;				// Vanilla: -1
	}
});
