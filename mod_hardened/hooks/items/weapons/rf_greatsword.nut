::Hardened.HooksMod.hook("scripts/items/weapons/rf_greatsword", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 2000;	// Reforged: 2400
	}
});
