::Hardened.HooksMod.hook("scripts/items/weapons/fighting_axe", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 2300;	// In Vanilla this is 2800
	}
});
