::Hardened.HooksMod.hook("scripts/skills/perks/perk_fast_adaption", function(q) {
	q.getName = @(__original) function()
	{
		local ret = __original();
		if (this.m.Stacks >= 1) ret += " (x" + this.m.Stacks + ")";		// QoL: show amount of stacks in the effect name
		return ret;
	}

	q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		__original(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);

		// Feat: We now allow attacks with multiple hits (e.g. Cascade, Hail) to trigger this perk on each attack
		// We do this by setting SkillCount to an invalid value, disabling the vanilla check in the process
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
