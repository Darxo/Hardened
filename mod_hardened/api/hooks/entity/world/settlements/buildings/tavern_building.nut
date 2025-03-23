::Hardened.HooksMod.hook("scripts/entity/world/settlements/buildings/tavern_building", function(q) {
	// Public
	q.m.MaximumRumors <- 3;	// The player can only receive this many paid rumors per day. In Vanilla this is 3, but hard-coded via magic numbers

	// Private
	q.m.HD_VanillaMaximum <- 3;	// This needs to be adjusted, if vanilla ever changes their magicnumber

	q.getRumor = @(__original) function( _isPaidFor = false )
	{
		local actualRumorsGiven = this.m.RumorsGiven;

		local dummyRumorsGiven = this.getAsVanillaRumorsGiven();
		this.m.RumorsGiven = dummyRumorsGiven;
		local ret = __original(_isPaidFor);
		local paidRumorDifference = this.m.RumorsGiven - dummyRumorsGiven;

		this.m.RumorsGiven = actualRumorsGiven + paidRumorDifference;

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
});
