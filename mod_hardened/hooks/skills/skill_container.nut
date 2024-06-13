::Hardened.HooksMod.hook("scripts/skills/skill_container", function(q) {
// Reforged Functions
	q.onDeath = @(__original) function( _fatalityType )
	{
		// Outside of battle items are now always moved to the stash, when the actor "dies" (as in leaving the company and world)
		if (!::MSU.Utils.hasState("tactical_state"))
		{
			this.getActor().getItems().transferToStash(::World.Assets.getStash());
		}

		__original(_fatalityType);
	}
});
