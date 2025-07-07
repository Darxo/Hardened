::Hardened.HooksMod.hook("scripts/items/supplies/armor_parts_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.IsDroppedAsLoot = true;

		this.m.HD_IsBuildingSupply = true;
	}

	// Feat: We merge bought tools immediately with the supplies
	q.onAddedToStash = @(__original) function( _stashID )
	{
		__original(_stashID);
		if (!::Hardened.Temp.LootAllItemsButtonPressed && _stashID == "player")
		{
			this.consume();
			::World.Assets.getStash().remove(this);
		}
	}
});
