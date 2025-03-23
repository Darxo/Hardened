::Hardened.HooksMod.hook("scripts/entity/world/settlements/buildings/tavern_building", function(q) {

	q.getRumor = @(__original) function( _isPaidFor = false )
	{
		local ret = __original(_isPaidFor);

		// In Vanilla this starts at 0, but shows you already a free rumor when accessing the tavern
		ret = "[Rumors Given: " + ::Math.min(this.m.RumorsGiven + 1, this.m.MaximumRumors + 1) + "/" + (this.m.MaximumRumors + 1) + "]\n" + ret;

		return ret;
	}
});
