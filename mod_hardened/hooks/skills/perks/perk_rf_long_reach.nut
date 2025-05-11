::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_long_reach", function(q) {
// Reforged Functions
	q.isEnabled = @(__original) function()
	{
		// This perk is now only active while this actor is NOT the active entity
		return __original() && !this.getContainer().getActor().isActiveEntity();
	}

// New Functions
	// Is called from actor.__calculateSurroundedCount to check if the character has a valid skill to apply the surround bonus
	// This function expects our actor to be isPlacedOnMap
	q.getSurroundedModifier <- function( _target )
	{
		if (!this.isEnabled()) return 0;

		foreach (skill in this.getContainer().getAllSkillsOfType(::Const.SkillType.Active))
		{
			if (this.isSkillValid(skill) && skill.verifyTargetAndRange(this.getContainer().getActor().getTile(), _target.getTile()))
			{
				return 1;
			}
		}

		return 0;
	}
});
