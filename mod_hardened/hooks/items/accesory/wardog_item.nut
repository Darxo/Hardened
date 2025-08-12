::Hardened.HooksMod.hook("scripts/items/accessory/wardog_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 250;		// Vanilla: 200
	}
});
