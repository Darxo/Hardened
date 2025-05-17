::Hardened.HooksMod.hook("scripts/items/armor/barbarians/scrap_metal_armor", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// this.m.Value = 130;			// In Vanilla this is 130
		this.m.ConditionMax = 80; 		// In Vanilla this is 75
		this.m.StaminaModifier = -12; 	// In Vanilla this is -8
	}
});
