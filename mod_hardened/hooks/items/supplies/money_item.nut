::Hardened.HooksMod.hook("scripts/items/supplies/money_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.IsDroppedAsLoot = true;
	}
});
