::Hardened.HooksMod.hook("scripts/items/helmets/barbarians/crude_faceguard_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 650;				// Vanilla: 650
		this.m.ConditionMax = 160;		// Vanilla: 160
		this.m.StaminaModifier = -15;	// Vanilla: -15
		this.m.Vision = -3;				// Vanilla: -2
	}
});
