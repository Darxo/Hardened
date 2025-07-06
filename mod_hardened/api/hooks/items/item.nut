::Hardened.HooksMod.hookTree("scripts/items/item", function(q) {
	// Public
	if (!"StaminaModifier" in q.m) q.m.StaminaModifier <- 0;
	q.m.HD_IsBuildingSupply <- false;
	q.m.HD_IsMedical <- false;
	q.m.HD_IsMineral <- false;

	q.create = @(__original) function()
	{
		__original();
		this.m.Condition = ::Math.minf(this.m.Condition, this.m.ConditionMax);	// Prevent Condition from ever being larger than ConditionMax
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
