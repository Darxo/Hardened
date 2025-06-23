::Hardened.HooksMod.hook("scripts/items/helmets/barbarians/heavy_horned_plate_helmet", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 1500;			// Vanilla: 1300
		this.m.ConditionMax = 250;		// Vanilla: 250
		this.m.StaminaModifier = -23;	// Vanilla: -23
		this.m.Vision = -3;				// Vanilla: -3
	}
});
