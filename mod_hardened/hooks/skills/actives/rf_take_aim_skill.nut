::Hardened.HooksMod.hook("scripts/skills/actives/rf_take_aim_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "Put additional effort into getting a better aim with crossbows or further aim with firearms.";
		this.m.SoundOnUse = [	// Reforged: []
			"sounds/combat/reload_01.wav",
			"sounds/combat/reload_02.wav",
		];
		this.m.ActionPointCost = 3;		// Reforged: 2
		this.m.FatigueCost = 25;		// In Reforged this is 25
	}
});
