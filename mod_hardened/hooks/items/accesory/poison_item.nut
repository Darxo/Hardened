::Hardened.HooksMod.hook("scripts/items/accessory/poison_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 200;		// Vanilla: 100
	}
});
