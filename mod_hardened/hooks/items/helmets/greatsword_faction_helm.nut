::Hardened.HooksMod.hook("scripts/items/helmets/greatsword_faction_helm", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 1500;			// Vanilla: 850; Reforged: 2000
		this.m.ConditionMax = 160;		// Vanilla: 160
		this.m.StaminaModifier = -8;	// Vanilla: -7
		this.m.Vision = -1;				// Vanilla: -1
	}
});
