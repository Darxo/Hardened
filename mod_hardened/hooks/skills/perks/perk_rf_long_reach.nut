::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_long_reach", function(q) {
// Reforged Functions
	q.isEnabled = @(__original) function()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isActiveEntity()) return false;		// This perk is now only active while this actor is NOT the active entity
		if (actor.getCurrentProperties().IsStunned) return false;
		if (actor.getMoraleState() == ::Const.MoraleState.Fleeing) return false;

		return __original();
	}

// New Functions
	// Is called from actor.__calculateSurroundedCount to check if the character has a valid skill to apply the surround bonus
	// This function expects our actor to be isPlacedOnMap
	q.getSurroundedModifier <- function( _target )
	{
		if (!this.isEnabled()) return 0;

		foreach (skill in this.getContainer().getAllSkillsOfType(::Const.SkillType.Active))
		{
			if (this.isSkillValid(skill) && skill.verifyTargetAndRange(_target.getTile()))
			{
				return 1;
			}
		}

		return 0;
	}
});
