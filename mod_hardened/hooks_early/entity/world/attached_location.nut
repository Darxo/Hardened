::Hardened.HooksMod.hook("scripts/entity/world/attached_location", function(q) {
	// Feat: Display the original location name for ruined
	q.getName = @() function()
	{
		return this.world_entity.getName() + (!this.isActive() ? " (Ruins)" : "");
	}
});
