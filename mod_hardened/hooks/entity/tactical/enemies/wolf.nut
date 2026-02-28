::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/wolf", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// Wolfs (spawned by goblin wolfrider), no longer randomly have actions in the same turn
		// IsActingImmediately only allows a freshly spawned unit to have actions, if no unit was removed from the turn sequence bar recently (past 0.5 seconds in Hardened)
		// So this only happens, if the goblin wolfrider already ended its turn in this round and you kill it then
		this.m.IsActingImmediately = false;
	}

// Reforged Functions
	q.onSpawned = @(__original) function()
	{
		__original();
		this.getSkills().add(::new("scripts/skills/effects/hd_bite_reach"));
	}
});
