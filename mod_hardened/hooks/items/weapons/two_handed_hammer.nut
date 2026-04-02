::Hardened.HooksMod.hook("scripts/items/weapons/two_handed_hammer", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.RegularDamageMax = 55;	// Vanilla: 60
		this.m.RegularDamageMax = 75;	// Vanilla: 90
		this.m.ArmorDamageMult = 2.5;	// Vanilla: 2.0
	}
});
