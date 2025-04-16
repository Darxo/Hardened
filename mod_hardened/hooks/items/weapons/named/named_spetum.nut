::Hardened.HooksMod.hook("scripts/items/weapons/named/named_spetum", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 2800;	// In Reforged this is 3500, In Vanilla this is 2800
	}
});
