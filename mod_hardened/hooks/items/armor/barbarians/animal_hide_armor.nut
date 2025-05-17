::Hardened.HooksMod.hook("scripts/items/armor/barbarians/animal_hide_armor", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// this.m.Value = 80;			// In Vanilla this is 80
		this.m.ConditionMax = 50; 		// In Vanilla this is 45
		this.m.StaminaModifier = -8; 	// In Vanilla this is -3
	}
});
