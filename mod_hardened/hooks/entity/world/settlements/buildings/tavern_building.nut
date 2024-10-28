::Hardened.HooksMod.hook("scripts/entity/world/settlements/buildings/tavern_building", function(q) {
	// Private
	q.m.HD_MaximumRumors <- 4;	// This number is just visually and needs to be adjusted, once Vanilla or a mod changes the maximum

	q.getRumor = @(__original) function( _isPaidFor = false )
	{
		local ret = __original(_isPaidFor);

		// In Vanilla this starts at 0, but shows you already a free rumor when accessing the tavern
		ret = "[Rumors Given: " + ::Math.min(this.m.RumorsGiven + 1, this.m.HD_MaximumRumors) + "/" + this.m.HD_MaximumRumors + "]\n" + ret;

		return ret;
	}
});
