::Hardened.HooksMod.hook("scripts/skills/perks/perk_overwhelm", function(q) {
	q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		__original(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);

		// Feat: We now allow attacks with multiple hits (e.g. Cascade, Hail) to trigger this perk on each attack
		// We do this by setting SkillCount to an invalid value, disabling the vanilla check in inthethe process
		this.m.SkillCount = null;
	}

	q.onTargetMissed = @(__original) function( _skill, _targetEntity )
	{
		__original(_skill, _targetEntity);

		// Feat: We now allow attacks with multiple hits (e.g. Cascade, Hail) to trigger this perk on each attack
		// We do this by setting SkillCount to an invalid value, disabling the vanilla check in the process
		this.m.SkillCount = null;
	}
});
