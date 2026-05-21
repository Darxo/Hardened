::Hardened.HooksMod.hook("scripts/items/weapons/oriental/qatal_dagger", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ArmorDamageMult = 0.5;	// Vanilla: 0.7
	}
});
