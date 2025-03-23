::Hardened.HooksMod.hook("scripts/items/item_container", function(q) {
	// Overwrite, because we implement our own condition for when loot may drops out of the item_container
	q.canDropItems = @() function( _killer )
	{
		return this.getActor().isLootAssignedToPlayer(_killer);
	}
});
