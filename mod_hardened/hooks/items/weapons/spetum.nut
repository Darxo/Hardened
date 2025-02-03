::Hardened.HooksMod.hook("scripts/items/weapons/spetum", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 900;	// In Vanilla this is 750
		this.m.Reach = 7;	// In Reforged this is 6
	}
});
