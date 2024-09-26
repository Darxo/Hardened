::Hardened.HooksMod.hook("scripts/items/supplies/medicine_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.IsDroppedAsLoot = true;
	}
});
