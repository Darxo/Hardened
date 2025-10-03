::Hardened.HooksMod.hook("scripts/entity/world/locations/goblin_hideout_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 80;		// Vanilla: 70
	}
});
