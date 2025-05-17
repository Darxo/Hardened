::Hardened.HooksMod.hook("scripts/items/armor/barbarians/thick_furs_armor", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// this.m.Value = 40;			// In Vanilla this is 40
		this.m.ConditionMax = 40; 		// In Vanilla this is 30
		this.m.StaminaModifier = -7; 	// In Vanilla this is -1
	}
});
