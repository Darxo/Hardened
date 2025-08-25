::Hardened.HooksMod.hook("scripts/items/supplies/cured_rations_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 300;		// Vanilla: 150

		this.m.HD_MaxAmount = 50;	// Vanilla: 25
	}
});
