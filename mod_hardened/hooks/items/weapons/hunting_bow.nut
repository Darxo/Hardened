::Hardened.HooksMod.hook("scripts/items/weapons/hunting_bow", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ArmorDamageMult = 0.5;	// Vanilla: 0.55
	}
});
