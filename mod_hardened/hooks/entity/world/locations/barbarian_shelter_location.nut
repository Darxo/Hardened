::Hardened.HooksMod.hook("scripts/entity/world/locations/barbarian_shelter_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 80;		// Vanilla: 75
	}
});
