::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_from_all_sides", function(q) {
	// We overwrite this because flail mastery no longer adds the perk_rf_from_all_sides no longer adds a debuff to the target
	q.onBeforeTargetHit = @() function( _skill, _targetEntity, _hitInfo ) {}

// Hardened Functions
	q.onReallyAfterSkillExecuted = @(__original) function( _skill, _targetTile, _success )
	{
		__original(_skill, _targetTile, _success);

		if (this.isSkillValid(_skill))
		{
			this.getContainer().add(::new("scripts/skills/effects/rf_from_all_sides_effect"));
		}
	}

// Reforged Functions
	// Overwrite, because we implement a new and simpler condition for this perk
	q.isSkillValid = @() function( _skill )
	{
		if (_skill == null) return false;

		return _skill.isAttack() && !_skill.isRanged();
	}
});
