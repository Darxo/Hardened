::Hardened.HooksMod.hookTree("scripts/items/item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Condition = ::Math.minf(this.m.Condition, this.m.ConditionMax);	// Prevent Condition from ever being larger than ConditionMax
	}

	// We re-implement a few multipliers in a much more compatible way, that vanilla handled in a more hard-coded fashion
	// This is guaranteed to only be called, if ::World.State.getCurrentTown() can be called and doesnt return null
	q.getBuyPriceMult = @(__original) function()
	{
		local currentTown = ::World.State.getCurrentTown();
		// We switcheroo BuildingPriceMult and MedicalPriceMult to disable cases where vanilla applies them selectively, as we want to apply them consistently
		local oldBuildingPriceMult = currentTown.getModifiers().BuildingPriceMult;
		local oldMedicalPriceMult = currentTown.getModifiers().MedicalPriceMult;
		currentTown.getModifiers().BuildingPriceMult = 1.0;
		currentTown.getModifiers().MedicalPriceMult = 1.0;

		local ret = __original();

		currentTown.getModifiers().BuildingPriceMult = oldBuildingPriceMult;
		currentTown.getModifiers().MedicalPriceMult = oldMedicalPriceMult;

		ret *= this.getBaseBuyPriceMult();	// Base Price can differ, depending on whether the item is produced here

		ret *= currentTown.getBuyPriceMult();	// In Vanilla this is multiplied in the getBuyPrice implementation

		ret *= ::Const.Difficulty.BuyPriceMult[::World.Assets.getEconomicDifficulty()];

		if (this.isBuildingSupply())
		{
			ret *= currentTown.getModifiers().BuildingPriceMult;
		}

		if (this.isMedical())
		{
			ret *= currentTown.getModifiers().MedicalPriceMult;
		}

		// Vanilla also has a magicnumber multiplier only for ItemType.Loot of 1.5
		// Presumably to prevent re-buying of loot items directly after a town situation ended
		// We don't support that anymore just to see what that would result in

		return ret;
	}

	// We re-implement a few multipliers in a much more compatible way, that vanilla handled in a more hard-coded fashion
	// This is guaranteed to only be called, if ::World.State.getCurrentTown() can be called and doesnt return null
	q.getSellPriceMult = @(__original) function()
	{
		local currentTown = ::World.State.getCurrentTown();
		// We switcheroo BuildingPriceMult and MedicalPriceMult to disable cases where vanilla applies them selectively, as we want to apply them consistently
		local oldBuildingPriceMult = currentTown.getModifiers().BuildingPriceMult;
		local oldMedicalPriceMult = currentTown.getModifiers().MedicalPriceMult;
		currentTown.getModifiers().BuildingPriceMult = 1.0;
		currentTown.getModifiers().MedicalPriceMult = 1.0;

		local ret = __original();

		currentTown.getModifiers().BuildingPriceMult = oldBuildingPriceMult;
		currentTown.getModifiers().MedicalPriceMult = oldMedicalPriceMult;

		ret *= this.getBaseSellPriceMult();	// Base Price can depend on itemtype (e.g. loot, or on whether the item is produced here)

		ret *= currentTown.getSellPriceMult();	// In Vanilla this is multiplied in the getBuyPrice implementation

		ret *= ::Const.Difficulty.SellPriceMult[::World.Assets.getEconomicDifficulty()];

		if (this.isBuildingSupply())
		{
			ret *= currentTown.getModifiers().BuildingPriceMult;
		}

		if (this.isMedical())
		{
			ret *= currentTown.getModifiers().MedicalPriceMult;
		}

		return ret;
	}
});

::Hardened.HooksMod.hook("scripts/items/item", function(q) {
	// Defines whether this item should be treated as "Sold recently"
	q.setSold = @(__original) function( _isSold )
	{
		__original(_isSold);

		if (_isSold)	// This being true is an indicator, that the player just sold this item to a shop
		{
			// We don't count trade goods as "Sold", if they were bought by us just moments before
			if (this.m.HD_BuyBackPrice != null && this.isItemType(::Const.Items.ItemType.TradeGood))
			{
				::World.Statistics.getFlags().increment("TradeGoodsSold", -1);
			}

			this.m.HD_BuyBackPrice = this.getSellPrice();
		}
	}

	// Defines whether this item should be treated as "Bought recently"
	q.setBought = @(__original) function( _isBought )
	{
		__original(_isBought);

		if (_isBought)	// This being true is an indicator, that the player just bought this item from a shop
		{
			// We don't count trade goods as "Bought", if they were sold by us just moments before
			if (this.m.HD_BuyBackPrice != null && this.isItemType(::Const.Items.ItemType.TradeGood))
			{
				::World.Statistics.getFlags().increment("TradeGoodsBought", -1);
			}

			this.m.HD_BuyBackPrice = this.getBuyPrice();
		}
	}

// Hardened Functions
	q.getRarityMult = @(__original) function( _settlement = null )
	{
		local ret = __original();

		if (_settlement != null)
		{
			if (this.isBuildingSupply())
			{
				ret *= _settlement.getModifiers().BuildingRarityMult;
			}

			if (this.isMedical())
			{
				ret *= _settlement.getModifiers().MedicalRarityMult;
			}

			if (this.isMineral())
			{
				ret *= _settlement.getModifiers().MineralRarityMult;
			}
		}

		return ret;
	}

// New Events
	// Triggers directly after unEquipping this item, after all connections to the item container have been severed
	// This can be used by items which trigger updates on other entities, whose effects might rely on the equip-state of this item
	q.HD_onAfterUnEquip <- function()
	{
	}
});
