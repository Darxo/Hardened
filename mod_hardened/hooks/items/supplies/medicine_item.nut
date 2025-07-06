::Hardened.HooksMod.hook("scripts/items/supplies/medicine_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.IsDroppedAsLoot = true;

		this.m.HD_IsMedical = true;
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

// Hardened Functions
	q.isBuildingPresent = @(__original) function( _settlement )
	{
		return __original(_settlement) || _settlement.hasAttachedLocation("attached_location.mushroom_grove") || _settlement.hasAttachedLocation("attached_location.gatherers_hut");
	}

	q.getBaseBuyPriceMult = @(__original) function()
	{
		if (this.isBuildingPresent(::World.State.getCurrentTown()))
		{
			return __original();
		}
		else
		{
			return ::Const.World.Assets.BuyPriceNotProducedHere;
		}
	}

	q.getBaseSellPriceMult = @(__original) function()
	{
		if (this.isBuildingPresent(::World.State.getCurrentTown()))
		{
			return __original();
		}
		else
		{
			return ::Const.World.Assets.SellPriceNotProducedHere;
		}
	}
});
