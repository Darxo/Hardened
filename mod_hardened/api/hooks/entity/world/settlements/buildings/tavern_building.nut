::Hardened.HooksMod.hook("scripts/entity/world/settlements/buildings/tavern_building", function(q) {
	// Public
	q.m.MaximumRumors <- 3;	// The player can only receive this many paid rumors per day. In Vanilla this is 3, but hard-coded via magic numbers

	// Private
	q.m.HD_VanillaMaximum <- 3;	// This needs to be adjusted, if vanilla ever changes their magicnumber

	q.getRumor = @(__original) function( _isPaidFor = false )
	{
		local mockGetMoney;
		local mockAddMoney;
		if (_isPaidFor)
		{
			if (!this.hasEnoughMoney()) return null;	// Same as vanilla

			// We pay the money here, because the vanilla payment method is hard-coded and doesn't use their own getter function
			::World.Assets.addMoney(-1 * this.getRumorPrice());

			// We mock getMoney, to make vanilla believe we have enough money
			mockGetMoney = ::Hardened.mockFunction(::World.Assets, "getMoney", function() {
				return { done = true, value = 9999 };	// The only important thing is, that it seems like we have enough money to spend, for the next time this is called
			});

			// We mock setMoney, to prevent Vanilla from removing the wrong amount
			mockAddMoney = ::Hardened.mockFunction(::World.Assets, "addMoney", function( _money ) {
				return { done = true, value = null };	// Return value doesn't matter. We just dont want the original to be called
			});
		}

		local actualRumorsGiven = this.m.RumorsGiven;

		local dummyRumorsGiven = this.getAsVanillaRumorsGiven();
		this.m.RumorsGiven = dummyRumorsGiven;
		local ret = __original(_isPaidFor);
		local paidRumorDifference = this.m.RumorsGiven - dummyRumorsGiven;

		this.m.RumorsGiven = actualRumorsGiven + paidRumorDifference;

		if (_isPaidFor)
		{
			mockGetMoney.cleanup();
			mockAddMoney.cleanup();
		}

		return ret;
	}

// New Functions
	// Translate the current this.m.RumorsGiven into a value, that works within the vanilla hard-coded boundaries
	q.getAsVanillaRumorsGiven <- function()
	{
		if (this.m.RumorsGiven < this.m.HD_VanillaMaximum)
		{
			return this.m.RumorsGiven;	// Here we don't have to lie yet
		}
		else if (this.m.RumorsGiven < this.m.MaximumRumors)
		{
			return this.m.HD_VanillaMaximum - 1;	// We need to stay below the vanilla maximum, so that rumors are still generated
		}
		else
		{
			return ::Math.max(this.m.RumorsGiven, this.m.HD_VanillaMaximum);	// No need to lie anymore
		}
	}

	q.hasEnoughMoney <- function()
	{
		return ::World.Assets.getMoney() >= this.getRumorPrice();
	}
});
