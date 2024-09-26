::Hardened.HooksMod.hook("scripts/items/supplies/ammo_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.IsDroppedAsLoot = true;
	}
});
