::Hardened.HooksMod.hook("scripts/items/supplies/cured_venison_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 115;		// Vanilla: 95

		this.m.HD_MaxAmount = 30;	// Vanilla: 25
	}
});
