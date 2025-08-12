::Hardened.HooksMod.hook("scripts/items/accessory/warhound_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 400;		// Vanilla: 300
	}
});
