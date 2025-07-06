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

// Hardened Functions
	q.isBuildingPresent = @(__original) function( _settlement )
	{
		return __original(_settlement) || _settlement.hasAttachedLocation("attached_location.leather_tanner") ||_settlement.hasBuilding("building.armorsmith") || _settlement.hasBuilding("building.armorsmith_oriental") || _settlement.hasBuilding("building.weaponsmith") || _settlement.hasBuilding("building.weaponsmith_oriental");
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
