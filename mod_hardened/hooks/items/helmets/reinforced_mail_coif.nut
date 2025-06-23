::Hardened.HooksMod.hook("scripts/items/helmets/reinforced_mail_coif", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 600;				// Vanilla: 300; Reforged: 600
		this.m.ConditionMax = 120; 		// Vanilla: 100
		this.m.StaminaModifier = -6; 	// Vanilla: -5
		this.m.Vision = -2;				// Vanilla: -1
	}
});
