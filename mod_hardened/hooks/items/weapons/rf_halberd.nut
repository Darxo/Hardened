::Hardened.HooksMod.hook("scripts/items/weapons/rf_halberd", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Reach = 6;	// In Reforged this is 7
	}
});
