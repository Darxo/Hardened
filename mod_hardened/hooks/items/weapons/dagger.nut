::Hardened.HooksMod.hook("scripts/items/weapons/dagger", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.RegularDamage = 20;		// Vanilla: 15
		this.m.RegularDamageMax = 30;	// Vanilla: 35
	}
});
