::Hardened.HooksMod.hook("scripts/items/armor/cultist_leather_robe", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 300;				// In Vanilla this is 240
		this.m.ConditionMax = 90; 		// In Vanilla this is 88
		this.m.StaminaModifier = -10; 	// In Vanilla this is -9
	}
});
