::Hardened.HooksMod.hook("scripts/items/helmets/steppe_helmet_with_mail", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 1250;			// Vanilla: 1250; Reforged: 1500
		this.m.ConditionMax = 200; 		// Vanilla: 200
		this.m.StaminaModifier = -14; 	// Vanilla: -12; Reforged: -11
		this.m.Vision = -2;				// Vanilla: -2; Reforged: -1
	}
});
