::Hardened.HooksMod.hook("scripts/items/armor/barbarians/heavy_iron_armor", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 1000;			// In Vanilla this is 700
		// this.m.ConditionMax = 170; 	// In Vanilla this is 170
		// this.m.StaminaModifier = -24; 	// In Vanilla this is -24
	}
});
