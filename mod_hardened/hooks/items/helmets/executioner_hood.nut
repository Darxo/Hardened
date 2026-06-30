::Hardened.HooksMod.hook("scripts/items/helmets/executioner_hood", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 150;				// Vanilla: 40
		this.m.ConditionMax = 80; 		// Vanilla: 40
		this.m.StaminaModifier = -5; 	// Vanilla: 0
		this.m.Vision = -3;				// Vanilla: -1
	}
});
