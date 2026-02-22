::Hardened.HooksMod.hook("scripts/items/helmets/oriental/assassin_face_mask", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 1800;			// Vanilla: 1800
		this.m.ConditionMax = 150; 		// Vanilla: 140
		this.m.StaminaModifier = -6; 	// Vanilla: -6
		this.m.Vision = -3;				// Vanilla: -1; Reforged: -3
	}
});
