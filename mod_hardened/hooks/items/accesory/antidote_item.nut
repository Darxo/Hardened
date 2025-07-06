::Hardened.HooksMod.hook("scripts/items/accessory/antidote_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 100;	// In Vanilla this is 150

		this.m.HD_IsMedical = true;
	}
});
