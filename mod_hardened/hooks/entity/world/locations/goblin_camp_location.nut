::Hardened.HooksMod.hook("scripts/entity/world/locations/goblin_camp_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 150;		// Vanilla: 120
	}
});
