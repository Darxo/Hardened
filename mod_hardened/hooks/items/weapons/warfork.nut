::Hardened.HooksMod.hook("scripts/items/weapons/warfork", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 550;		// In Vanilla this is 400
		this.m.ArmorDamageMult = 0.9;	// In Vanilla this is 1.0
	}
});
