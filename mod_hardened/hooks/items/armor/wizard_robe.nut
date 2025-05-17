::Hardened.HooksMod.hook("scripts/items/armor/wizard_robe", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 150;				// In Vanilla this is 60
		// this.m.ConditionMax = 30; 	// In Vanilla this is 20
		this.m.StaminaModifier = -1; 	// In Vanilla this is 0
	}
});
