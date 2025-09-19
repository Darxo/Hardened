::Hardened.HooksMod.hook("scripts/items/special/broken_ritual_armor_item", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 5000;	// Vanilla: 1000
	}
});

