::Hardened.HooksMod.hook("scripts/entity/world/locations/barbarian_camp_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 200;		// Vanilla: 180
	}
});
