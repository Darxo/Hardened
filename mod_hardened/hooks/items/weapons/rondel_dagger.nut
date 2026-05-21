::Hardened.HooksMod.hook("scripts/items/weapons/rondel_dagger", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 500;				// Vanilla: 400
		this.m.RegularDamage = 25;		// Vanilla: 20
		this.m.RegularDamageMax = 35;	// Vanilla: 40
		this.m.ArmorDamageMult = 0.5;	// Vanilla: 0.7
	}
});
