::Hardened.HooksMod.hook("scripts/items/tools/holy_water_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 400; 	// Vanilla: 100
	}
});
