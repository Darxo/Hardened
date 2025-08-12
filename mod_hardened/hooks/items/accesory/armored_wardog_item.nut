::Hardened.HooksMod.hook("scripts/items/accessory/armored_wardog_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 450;		// Vanilla: 400
	}
});
