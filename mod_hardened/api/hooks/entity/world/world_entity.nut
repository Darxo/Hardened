::Hardened.HooksMod.hook("scripts/entity/world/world_entity", function(q) {
// New Functions
	// @return an integer representing the last number in this parties player banner brush
	// @return -1 if no player banner brush could be found
	q.getBannerID <- function()
	{
		if (this.hasSprite("banner"))
		{
			local bannerSprite = this.getSprite("banner");
			if (bannerSprite.HasBrush)
			{
				local stringIndex = bannerSprite.getBrush().Name.find("banner_");
				try {	// Non-player banner used here will throw errors
					return bannerSprite.getBrush().Name.slice(stringIndex + 7).tointeger();	// +7 because "banner_" are 7 characters and we wanna point to the first character after this
				}
				catch (err) {}	// Do nothing
			}
		}
		return -1;
	}
});
