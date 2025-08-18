::Hardened.HooksMod.hookTree("scripts/items/item", function(q) {
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
});

::Hardened.HooksMod.hook("scripts/items/item", function(q) {
	// Public
	if (!"StaminaModifier" in q.m) q.m.StaminaModifier <- 0;
	q.m.HD_IsBuildingSupply <- false;
	q.m.HD_IsMedical <- false;
	q.m.HD_IsMineral <- false;

	// Private
	q.m.HD_BuyBackPrice <- null;

// Reintroduced Vanilla Functions
	// Returns the type of ammo, that this item represents.
	// In Vanilla this only exists in the base class ammo.nut, but not every item with the itemtype "ammo" inherits from that class.
	// In order to safely call getAmmoType on a supposed ammo item, we need to enable it for all types of items
	q.getAmmoType <- function()
	{
		return ::Const.Items.AmmoType.None;
	}

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
