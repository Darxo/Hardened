::Hardened.HooksMod.hook("scripts/items/supplies/food_item", function(q) {
	q.m.HD_MaxAmount <- 25;		// Maximum Stacksize of this food item. In Vanilla this is 25

	// Overwrite, because we change how the value is calculated and we use a variable maximum stack size
	q.getValue = @() function()
	{
		local value = this.m.Value;
		value *= this.HD_getShelfLifeMult();
		return ::Math.floor(this.m.Amount / this.m.HD_MaxAmount * value);
	}

	// Overwrite, because we make the randomization depending on new member variable
	q.randomizeAmount = @() function()
	{
		this.m.Amount = ::Math.rand(1, this.m.HD_MaxAmount);
	}

// New Functions
	// Return a multiplier for this items value that is calculated from its shelf life
	q.HD_getShelfLifeMult <- function()
	{
		return ::Math.minf(1.0, this.getSpoilInDays() / this.m.GoodForDays * 1.0);
	}
});
