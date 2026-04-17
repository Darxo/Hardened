::Hardened.HooksMod.hook("scripts/items/loot/rf_geist_tear_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 800;		// Reforged: 300
	}
});
