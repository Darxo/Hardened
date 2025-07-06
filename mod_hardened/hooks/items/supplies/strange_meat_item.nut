::Hardened.HooksMod.hook("scripts/items/supplies/strange_meat_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 35;		// Vanilla: 50
	}
});
