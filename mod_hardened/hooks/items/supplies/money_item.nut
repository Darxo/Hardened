::Hardened.HooksMod.hook("scripts/items/supplies/money_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.IsDroppedAsLoot = true;

		// We default the value and amount to 200, so that this item can now be used as produce for caravans
		this.setAmount(200);
	}

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
