::Hardened.HooksMod.hook("scripts/items/helmets/oriental/gladiator_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 2500;				// Vanilla: 2200
		this.m.ConditionMax = 230; 			// Vanilla: 225; Reforged: 230
		this.m.StaminaModifier = -13; 		// Vanilla: -13
		this.m.Vision = -4;					// Vanilla: -3
	}
});
