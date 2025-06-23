::Hardened.HooksMod.hook("scripts/items/helmets/cultist_leather_hood", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 90;				// Vanilla: 140
		this.m.ConditionMax = 80; 		// Vanilla: 60
		this.m.StaminaModifier = -7; 	// Vanilla: -3
		this.m.Vision = -3;				// Vanilla: -1
	}
});
