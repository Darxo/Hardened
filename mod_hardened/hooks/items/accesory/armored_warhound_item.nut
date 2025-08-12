::Hardened.HooksMod.hook("scripts/items/accessory/armored_warhound_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 600;		// Vanilla: 450
	}
});
