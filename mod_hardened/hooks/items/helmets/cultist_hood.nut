::Hardened.HooksMod.hook("scripts/items/helmets/cultist_hood", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 50;				// Vanilla: 20
		this.m.ConditionMax = 50; 		// Vanilla: 30
		this.m.StaminaModifier = -4; 	// Vanilla: 0
		this.m.Vision = -3;				// Vanilla: -1
	}
});
