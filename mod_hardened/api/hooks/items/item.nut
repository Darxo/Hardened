::Hardened.HooksMod.hookTree("scripts/items/item", function(q) {
	// Public
	if (!"StaminaModifier" in q.m) q.m.StaminaModifier <- 0;
	q.m.HD_IsBuildingSupply <- false;
	q.m.HD_IsMedical <- false;
	q.m.HD_IsMineral <- false;

	// Private
	q.m.HD_BuyBackPrice <- null;

	q.create = @(__original) function()
	{
		__original();
		this.m.Condition = ::Math.minf(this.m.Condition, this.m.ConditionMax);	// Prevent Condition from ever being larger than ConditionMax
	}

	// Overwrite, because we completely re-implement and standardize the pricing function for items
	// 		This will also destroy many attempts by mods to hook this function
	// This function is the top level for calculating the buy-price of an item
	// It determines which calculation to use, depending on whether we are in a town
	q.getBuyPrice = @() function()
	{
		if (this.m.HD_BuyBackPrice != null) return this.m.HD_BuyBackPrice;

		local buyPrice = this.getValue() * this.getPriceMult();

		if (("State" in ::World) && ::World.State != null && ::World.State.getCurrentTown() != null)
		{
			buyPrice *= this.getBuyPriceMult();
		}

		return ::Math.ceil(buyPrice);	// We cut off decimal places
	}

	// Overwrite, because we completely re-implement and standardize the pricing function for items
	// 		This will also destroy many attempts by mods to hook this function
	// This function is the top level for calculating the sell-price of an item
	// It determines which calculation to use, depending on whether we are in a town
	q.getSellPrice = @() function()
	{
		if (this.m.HD_BuyBackPrice != null) return this.m.HD_BuyBackPrice;

		local sellPrice = this.getValue();

		if (("State" in ::World) && ::World.State != null && ::World.State.getCurrentTown() != null)
		{
			sellPrice *= this.getSellPriceMult();
		}
		else
		{
			sellPrice *= ::Const.World.Assets.BaseSellPrice;
		}

		return ::Math.ceil(sellPrice);	// We cut off decimal places and round up. In Vanilla this is rounded down for some reason for selling
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

	// Defines whether this item should be treated as "Sold recently"
	q.setSold = @(__original) function( _isSold )
	{
		__original(_isSold);

		if (_isSold)	// This being true is an indicator, that the player just bought this item from a shop
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

		if (_isBought)	// This being true is an indicator, that the player just sold this item to a shop
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
});

::Hardened.HooksMod.hook("scripts/items/item", function(q) {
// New Getter/Setter
	// This is guaranteed to only be called, if ::World.State.getCurrentTown() can be called and doesnt return null
	q.getBaseBuyPriceMult <- function()
	{
		return ::Const.World.Assets.BaseBuyPrice;
	}

	// This is guaranteed to only be called, if ::World.State.getCurrentTown() can be called and doesnt return null
	q.getBaseSellPriceMult <- function()
	{
		if (this.isItemType(::Const.Items.ItemType.Loot))
		{
			return ::Const.World.Assets.BaseLootSellPrice;
		}
		else
		{
			return ::Const.World.Assets.BaseSellPrice;
		}
	}

	// @return true if this item is produced by any attached location of _settlement, or false otherwise
	// This might be extended to also return true, if a related building (that not necessarily produces the item in question) is present
	// 	This happens for example for armor parts, medicine, ammo and dried fish
	q.isBuildingPresent <- function( _settlement )
	{
		local scriptName = ::IO.scriptFilenameByHash(this.ClassNameHash);
		foreach (activeAttachedLocation in _settlement.getActiveAttachedLocations())
		{
			foreach (produce in activeAttachedLocation.getProduceList())
			{
				if (scriptName.find(produce) != null)	// Produce-Strings are just the identifying part of the script path
				{
					return true;
				}
			}
		}

		return false;
	}

	// Return the amount of items of this type that should be generated at most inside a shop, given enough rarity and luck
	q.getShopAmountMax <- function()
	{
		return 3;	// This is the standard vanilla value
	}

	// Return the rarityMult of this item during shop generation, making it more or less likely to appear multiple times
	// A higher RarityMult makes it more likely to pass additional RarityThreshold checks during shop generation
	// Can be hooked or overwritten by various item subclasses to add additional multipliers
	// @param _settlement is the settlement that we are currently in, as rarity is usually related to shops
	q.getRarityMult <- function( _settlement = null )
	{
		return 1.0;
	}

	q.getWeight <- function()
	{
		local staminaModifier = this.getStaminaModifier();
		return ::Math.max(0, -1 * staminaModifier);
	}

	// Set the stamina modifier of the item to the inverse of the passed value
	q.setWeight <- function( _weight )
	{
		this.m.StaminaModifier = -1 * _weight;
	}

	q.isBuildingSupply <- function()
	{
		return this.m.HD_IsBuildingSupply;
	}

	q.isMedical <- function()
	{
		return this.m.HD_IsMedical;
	}

	q.isMineral <- function()
	{
		return this.m.HD_IsMineral;
	}

	q.isNamed <- function()
	{
		return this.isItemType(::Const.Items.ItemType.Named);
	}

	// @return the brush name of this item, if it exists
	// @return null otherwise
	q.HD_getBrush <- function()
	{
		return null;
	}

	// @return the brush name of the silhouette that should be displayed for when this item is in a bag slot
	// @return null if no brush exists to be displayed
	// @return null if no silhouette should be displayed (e.g. due to mod settings)
	q.HD_getSilhouette <- function()
	{
		return this.HD_getBrush();
	}
});
