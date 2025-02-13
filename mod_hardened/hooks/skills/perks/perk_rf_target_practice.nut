::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_target_practice", function(q) {
	// Public
	q.m.RangedAttackBlockedChanceMult <- 0.5;

	q.onUpdate = @(__original) function( _properties )
	{
		if (this.isEnabled())
		{
			_properties.RangedAttackBlockedChanceMult *= this.m.RangedAttackBlockedChanceMult;
		}
	}

	// This perk no longer grants hitchance
	q.onAnySkillUsed = @() function( _skill, _targetEntity, _properties ) {}
// MSU Functions
	q.onGetHitFactors = @() function( _skill, _targetTile, _tooltip ) {}
});
