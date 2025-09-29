::Hardened.HooksMod.hook("scripts/items/supplies/food_item", function(q) {
	q.m.HD_MaxAmount <- 25;		// Maximum Stacksize of this food item. In Vanilla this is 25

	// Overwrite, because we change how the value is calculated and we use a variable maximum stack size
	q.getValue = @() function()
	{
		local value = this.m.Value;
		value *= this.HD_getShelfLifeMult();
		value *= (this.m.Amount * 1.0 / this.m.HD_MaxAmount);
		return ::Math.floor(value);
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.push({
			id = 68,
			type = "text",
			text = format("Contains %i/%i servings", this.m.Amount, this.m.HD_MaxAmount),
		});

		return ret;
	}

	// Overwrite, because we make the randomization depending on new member variable
	q.randomizeAmount = @() function()
	{
		this.m.Amount = ::Math.rand(1, this.m.HD_MaxAmount);
	}

	// Re-Implement the food price multipliers. Vanilla applies them in getBuyPrice function, but we overwrite that in Hardened
	q.getBuyPriceMult = @(__original) function()
	{
		return __original() * ::World.State.getCurrentTown().getFoodPriceMult();
	}

	// Re-Implement the food price multipliers. Vanilla applies them in getSellPrice function, but we overwrite that in Hardened
	q.getSellPriceMult = @(__original) function()
	{
		return __original() * ::World.State.getCurrentTown().getFoodPriceMult();
	}

// Hardened Functions
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
			// Generic Food Items are like trade goods except that they can go bad
			return ::Const.World.Assets.SellPriceNotProducedHere;
		}
	}

	q.getRarityMult = @(__original) function( _settlement = null )
	{
		local ret = __original();

		if (_settlement != null)
		{
			ret *= _settlement.getModifiers().FoodRarityMult;
		}

		return ret;
	}

// New Functions
	// Return a multiplier for this items value that is calculated from its shelf life
	q.HD_getShelfLifeMult <- function()
	{
		return ::Math.minf(1.0, this.getSpoilInDays() * 1.0 / this.m.GoodForDays);
	}
});

::Hardened.HooksMod.hookTree("scripts/items/supplies/food_item", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Amount = this.m.HD_MaxAmount;
	}
});
