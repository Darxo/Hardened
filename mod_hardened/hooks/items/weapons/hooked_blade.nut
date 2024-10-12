::Hardened.HooksMod.hook("scripts/items/weapons/hooked_blade", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 550;		// In Vanilla this is 700
		this.m.RegularDamageMax = 60;	// In Vanilla this is 70
	}
});
