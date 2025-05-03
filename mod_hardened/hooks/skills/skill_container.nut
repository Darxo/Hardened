::Hardened.HooksMod.hook("scripts/skills/skill_container", function(q) {
	q.onDeath = @(__original) function( _fatalityType )
	{
		// Outside of battle items are now always moved to the stash, when the actor "dies" (as in leaving the company and world)
		if (!::MSU.Utils.hasState("tactical_state"))
		{
			this.getActor().getItems().transferToStash(::World.Assets.getStash());
		}

		__original(_fatalityType);
	}

// New Functions
	// Helper function for AI considerations.
	// Return the cheapest melee attack, that this user has access to and can currently use.
	// Any additional MaxRange will be considered as it being 2 AP cheaper
	// @return reference to cheapest found attack skill
	// @return null, if no skill was found
	q.getCheapestAttack <- function()
	{
		local ret = null;
		local cheapestAP = 999;
		local apPerMaxRange = -2;

		local actor = this.getActor();
		foreach (i, skill in this.m.Skills)
		{
			if (!skill.isActive() || !skill.isAttack() || !skill.isTargeted() || skill.isDisabled() || !skill.isUsable())
			{
				continue;
			}

			local effectiveApCost = skill.getActionPointCost() + skill.getMaxRange() * apPerMaxRange;

			if (effectiveApCost <= cheapestAP)
			{
				ret = skill;
				cheapestAP = effectiveApCost;
			}
		}

		return ret;
	}
});
