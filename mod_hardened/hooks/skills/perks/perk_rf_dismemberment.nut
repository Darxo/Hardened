::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_dismemberment", function(q) {
	q.m.BodyPartHitChanceModifier <- 20;

	// Overwrite because we no longer inflict morale checks
	q.onTargetHit = @() function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor ) { }

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		__original(_skill, _targetEntity, _properties);

		if (_targetEntity == null) return;
		if (!this.isSkillValid(_skill)) return;

		local bodyPartCounter = 0;
		foreach (tempInjury in _targetEntity.getSkills().getAllSkillsOfType(::Const.SkillType.TemporaryInjury))
		{
			if (tempInjury.m.AffectedBodyPart == ::Const.BodyPart.Head) ++bodyPartCounter;
			if (tempInjury.m.AffectedBodyPart == ::Const.BodyPart.Body) --bodyPartCounter;
		}

		if (bodyPartCounter > 0)
		{
			_properties.HitChance[::Const.BodyPart.Head] += this.m.BodyPartHitChanceModifier
		}
		else if (bodyPartCounter < 0)
		{
			_properties.HitChance[::Const.BodyPart.Head] -= this.m.BodyPartHitChanceModifier
		}
	}
});
