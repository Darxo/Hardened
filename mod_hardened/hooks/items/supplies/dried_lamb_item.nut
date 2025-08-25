::Hardened.HooksMod.hook("scripts/items/supplies/dried_lamb_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 125;		// Vanilla: 105

		this.m.HD_MaxAmount = 30;	// Vanilla: 25
	}
});
