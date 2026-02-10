::Hardened.HooksMod.hook("scripts/items/weapons/greenskins/goblin_crossbow", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.FatigueOnSkillUse = 2;	// In Vanilla this is 0

		this.m.DirectDamageMult = 0.4;	// Vanilla: 0.4
		this.m.ArmorDamageMult = 0.8;	// Vanilla: 0.75
	}
});

