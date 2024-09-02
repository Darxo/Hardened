::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_between_the_ribs", function(q) {
	q.m.HeadShotChancePerSurround <- -10;

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		__original(_skill, _targetEntity, _properties);
		if (_targetEntity != null && !_targetEntity.getCurrentProperties().IsImmuneToSurrounding && this.isSkillValid(_skill))
		{
			_properties.HitChance[::Const.BodyPart.Head] += _targetEntity.getSurroundedCount() * this.m.HeadShotChancePerSurround;
		}
	}
});
