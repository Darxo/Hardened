::Hardened.HooksMod.hook("scripts/items/supplies/money_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.IsDroppedAsLoot = true;
	}

	q.onAddedToStash = @(__original) function( _stashID )
	{
		__original(_stashID);
		if (_stashID == "player")
		{
			this.consume();
			::World.Assets.getStash().remove(this);
		}
	}
});
