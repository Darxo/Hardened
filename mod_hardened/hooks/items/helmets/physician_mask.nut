::Hardened.HooksMod.hook("scripts/items/helmets/physician_mask", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 150;				// Vanilla: 170; Reforged: 200
		this.m.ConditionMax = 70; 		// Vanilla: 70; Reforged: 75
		this.m.StaminaModifier = -5; 	// Vanilla: -3
		this.m.Vision = -3;				// Vanilla: -1
	}
});
