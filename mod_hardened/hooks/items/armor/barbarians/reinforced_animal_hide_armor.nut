::Hardened.HooksMod.hook("scripts/items/armor/barbarians/reinforced_animal_hide_armor", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// this.m.Value = 120;			// In Vanilla this is 120
		this.m.ConditionMax = 70; 		// In Vanilla this is 65
		this.m.StaminaModifier = -11; 	// In Vanilla this is -7
	}
});
